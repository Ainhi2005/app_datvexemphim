import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Dialog thêm/sửa Combo bắp nước.
class ComboFormDialog extends StatefulWidget {
  final dynamic combo; // null = thêm mới

  const ComboFormDialog({super.key, this.combo});

  static Future<Map<String, dynamic>?> show(BuildContext context, {dynamic combo}) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ComboFormDialog(combo: combo),
    );
  }

  @override
  State<ComboFormDialog> createState() => _ComboFormDialogState();
}

class _ComboFormDialogState extends State<ComboFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;
  late bool _isActive;
  String? _localImagePath;
  String? _currentImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final c = widget.combo;
    _nameCtrl = TextEditingController(text: c?['name'] ?? '');
    _priceCtrl = TextEditingController(text: c != null ? c['price'].toString() : '');
    _descCtrl = TextEditingController(text: c?['description'] ?? '');
    _isActive = c == null
        ? true
        : (c['isActive'] == true || c['isActive'] == 1 || c['is_active'] == true || c['is_active'] == 1);
    _currentImageUrl = c?['imageUrl'] ?? c?['image_url'];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (file != null) setState(() => _localImagePath = file.path);
    } catch (e) {
      debugPrint('Lỗi chọn ảnh combo: $e');
    }
  }

  void _submit() {
    final String name = _nameCtrl.text.trim();
    final String priceStr = _priceCtrl.text.trim();
    if (name.isEmpty || priceStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ các thông tin bắt buộc (*)')),
      );
      return;
    }
    final double? price = double.tryParse(priceStr);
    if (price == null || price < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giá bán không hợp lệ!')),
      );
      return;
    }
    Navigator.pop(context, {
      'name': name,
      'price': price,
      'description': _descCtrl.text.trim(),
      'isActive': _isActive,
      'localImagePath': _localImagePath,
      'currentImageUrl': _currentImageUrl,
    });
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
      );

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.combo != null;
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: Text(
        isEditing ? 'Chỉnh Sửa Combo' : 'Thêm Combo Mới',
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameCtrl, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('Tên combo *')),
            const SizedBox(height: 12),
            TextField(
              controller: _priceCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Giá bán (đ) *'),
            ),
            const SizedBox(height: 12),
            TextField(controller: _descCtrl, maxLines: 2, style: const TextStyle(color: Colors.white), decoration: _inputDecoration('Mô tả chi tiết')),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Trạng thái hoạt động', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Switch(
                  value: _isActive,
                  thumbColor: WidgetStatePropertyAll(Colors.amber),
                  onChanged: (val) => setState(() => _isActive = val),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Image picker
            InkWell(
              onTap: _pickImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E2E),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: _localImagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(File(_localImagePath!), fit: BoxFit.cover),
                      )
                    : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _currentImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.broken_image, color: Colors.grey, size: 36),
                              ),
                            ),
                          )
                        : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, color: Colors.amber, size: 28),
                              SizedBox(height: 6),
                              Text('Chọn ảnh Combo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          )),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          onPressed: _submit,
          child: const Text('Lưu', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
