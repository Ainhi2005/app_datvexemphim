import 'package:flutter/material.dart';

/// Dialog thêm/sửa phòng chiếu.
/// Gọi [RoomFormDialog.show] và nhận kết quả qua Future.
class RoomFormDialog extends StatefulWidget {
  final dynamic room; // null = thêm mới

  const RoomFormDialog({super.key, this.room});

  static Future<Map<String, dynamic>?> show(BuildContext context, {dynamic room}) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => RoomFormDialog(room: room),
    );
  }

  @override
  State<RoomFormDialog> createState() => _RoomFormDialogState();
}

class _RoomFormDialogState extends State<RoomFormDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _rowsCtrl;
  late final TextEditingController _colsCtrl;
  late String _type;

  @override
  void initState() {
    super.initState();
    final r = widget.room;
    _nameCtrl = TextEditingController(text: r?['name'] ?? '');
    _rowsCtrl = TextEditingController(text: r != null ? r['totalRows'].toString() : '8');
    _colsCtrl = TextEditingController(text: r != null ? r['seatsPerRow'].toString() : '10');
    _type = r?['type'] ?? 'STANDARD';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _rowsCtrl.dispose();
    _colsCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_nameCtrl.text.isEmpty) return;
    Navigator.pop(context, {
      'name': _nameCtrl.text.trim(),
      'type': _type,
      'totalRows': int.tryParse(_rowsCtrl.text) ?? 8,
      'seatsPerRow': int.tryParse(_colsCtrl.text) ?? 10,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.room != null;

    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: Text(
        isEditing ? 'Chỉnh Sửa Phòng' : 'Thêm Phòng Mới',
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Tên phòng',
              labelStyle: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFF1A1A1A),
            initialValue: _type,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Loại phòng',
              labelStyle: TextStyle(color: Colors.grey),
            ),
            items: ['STANDARD', 'VIP', 'IMAX']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _type = val);
            },
          ),
          // Số hàng / ghế chỉ hiện khi tạo mới
          if (!isEditing) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _rowsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Số hàng ghế (tối đa 26)',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _colsCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Số ghế mỗi hàng (tối đa 50)',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          onPressed: _submit,
          child: const Text('Lưu', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
