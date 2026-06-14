import 'package:flutter/material.dart';
import '../../../../data/repositories/user_repository.dart';
import '../../../../data/services/cinema_api_service.dart';
import 'widgets/combo_form_dialog.dart';
import 'widgets/combo_list_tile.dart';

class ManageCombosScreen extends StatefulWidget {
  const ManageCombosScreen({super.key});

  @override
  State<ManageCombosScreen> createState() => _ManageCombosScreenState();
}

class _ManageCombosScreenState extends State<ManageCombosScreen> {
  final CinemaApiService _api = CinemaApiService();
  List<dynamic> _combos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCombos();
  }

  // ─── Data ──────────────────────────────────────────────────────────────────

  Future<void> _loadCombos() async {
    setState(() => _isLoading = true);
    try {
      final data = await _api.getCombos();
      setState(() {
        _combos = data;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Lỗi tải danh sách Combo: $e');
    }
  }

  // ─── CRUD ──────────────────────────────────────────────────────────────────

  Future<void> _openComboDialog([dynamic combo]) async {
    final result = await ComboFormDialog.show(context, combo: combo);
    if (result == null) return;

    setState(() => _isLoading = true);
    try {
      String? imageUrl = result['currentImageUrl'];
      if (result['localImagePath'] != null) {
        imageUrl = await UserRepository().uploadImage(result['localImagePath']);
      }

      if (combo == null) {
        await _api.createCombo(
          name: result['name'],
          price: result['price'],
          description: result['description'],
          imageUrl: imageUrl,
        );
        _showSnack('Thêm Combo thành công!');
      } else {
        await _api.updateCombo(
          combo['id'],
          name: result['name'],
          price: result['price'],
          description: result['description'],
          imageUrl: imageUrl,
          isActive: result['isActive'],
        );
        _showSnack('Cập nhật Combo thành công!');
      }
      _loadCombos();
    } catch (e) {
      _handleError('Thao tác thất bại: $e');
    }
  }

  Future<void> _deleteCombo(int id) async {
    setState(() => _isLoading = true);
    try {
      await _api.deleteCombo(id);
      _showSnack('Xóa Combo thành công!');
      _loadCombos();
    } catch (e) {
      _handleError('Xóa Combo thất bại: $e');
    }
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _handleError(String msg) {
    setState(() => _isLoading = false);
    _showSnack(msg);
  }

  void _confirmDelete(dynamic combo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
        content: Text('Bạn có chắc muốn xóa combo ${combo['name']}?', style: const TextStyle(color: Colors.grey)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCombo(combo['id']);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Quản Lý Combo Bắp Nước',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _combos.isEmpty
              ? const Center(child: Text('Chưa có Combo nào', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _combos.length,
                  itemBuilder: (_, i) {
                    final combo = _combos[i];
                    return ComboListTile(
                      combo: combo,
                      onEdit: () => _openComboDialog(combo),
                      onDelete: () => _confirmDelete(combo),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: _openComboDialog,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
