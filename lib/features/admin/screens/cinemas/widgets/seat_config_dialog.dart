import 'package:flutter/material.dart';

/// Dialog cấu hình một ghế (loại ghế + trạng thái hoạt động).
class SeatConfigDialog extends StatefulWidget {
  final dynamic seat;

  const SeatConfigDialog({super.key, required this.seat});

  static Future<Map<String, dynamic>?> show(BuildContext context, {required dynamic seat}) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => SeatConfigDialog(seat: seat),
    );
  }

  @override
  State<SeatConfigDialog> createState() => _SeatConfigDialogState();
}

class _SeatConfigDialogState extends State<SeatConfigDialog> {
  late String _type;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _type = widget.seat['type'] ?? 'NORMAL';
    _isActive = widget.seat['isActive'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: Text(
        'Cấu Hình Ghế ${widget.seat['label']}',
        style: const TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            dropdownColor: const Color(0xFF1A1A1A),
          initialValue: _type,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Loại ghế',
              labelStyle: TextStyle(color: Colors.grey),
            ),
            items: ['NORMAL', 'VIP', 'COUPLE']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _type = val);
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Đang hoạt động', style: TextStyle(color: Colors.white)),
            value: _isActive,
            activeThumbColor: Colors.amber,
            onChanged: (val) => setState(() => _isActive = val),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          onPressed: () => Navigator.pop(context, {'type': _type, 'isActive': _isActive}),
          child: const Text('Lưu', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
