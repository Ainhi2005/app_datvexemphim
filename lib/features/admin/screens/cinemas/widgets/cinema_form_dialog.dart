import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Dialog thêm/sửa thông tin rạp chiếu phim.
/// Gọi [CinemaFormDialog.show] và nhận kết quả qua Future.
class CinemaFormDialog extends StatefulWidget {
  final dynamic cinema; // null = thêm mới, có data = chỉnh sửa

  const CinemaFormDialog({super.key, this.cinema});

  /// Trả về Map kết quả nếu người dùng bấm Lưu, null nếu hủy.
  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    dynamic cinema,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => CinemaFormDialog(cinema: cinema),
    );
  }

  @override
  State<CinemaFormDialog> createState() => _CinemaFormDialogState();
}

class _CinemaFormDialogState extends State<CinemaFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _phoneCtrl;
  String? _localImagePath;
  String? _currentImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final c = widget.cinema;
    _nameCtrl = TextEditingController(text: c?['name'] ?? '');
    _addressCtrl = TextEditingController(text: c?['address'] ?? '');
    _cityCtrl = TextEditingController(text: c?['city'] ?? '');
    _phoneCtrl = TextEditingController(text: c?['phone'] ?? '');
    _currentImageUrl = c?['imageUrl'] ?? c?['image_url'];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (file != null) setState(() => _localImagePath = file.path);
    } catch (e) {
      debugPrint('Lỗi chọn ảnh: $e');
    }
  }

  void _submit() {
    if (_nameCtrl.text.isEmpty || _addressCtrl.text.isEmpty || _cityCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên, địa chỉ và thành phố!')),
      );
      return;
    }
    Navigator.pop(context, {
      'name': _nameCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
      'city': _cityCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
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
    final isEditing = widget.cinema != null;

    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: Text(
        isEditing ? 'Chỉnh Sửa Rạp' : 'Thêm Rạp Mới',
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Tên rạp *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Địa chỉ *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Thành phố *'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Số điện thoại'),
            ),
            const SizedBox(height: 16),
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
                              Text('Chọn ảnh rạp', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
