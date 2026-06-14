import 'package:flutter/material.dart';
import 'package:tet/data/models/user_model.dart';
import '../../../../data/repositories/user_repository.dart';
import 'widgets/user_list_tile.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final UserRepository _userRepository = UserRepository();
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // ─── Data ──────────────────────────────────────────────────────────────────

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final data = await _userRepository.getAllUsers();
      setState(() {
        _users = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Lỗi tải danh sách người dùng: $e');
    }
  }

  // ─── Actions ───────────────────────────────────────────────────────────────

  Future<void> _toggleRole(UserModel user) async {
    final String newRole = user.role == 'admin' ? 'user' : 'admin';
    await _updateRole(user.id, user.name, newRole);
  }

  Future<void> _updateRole(int userId, String userName, String newRole) async {
    setState(() => _isLoading = true);
    try {
      await _userRepository.updateUserRole(userId, newRole);
      _showSnack('Cập nhật quyền của $userName thành $newRole thành công!');
      _loadUsers();
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Lỗi cập nhật quyền hạn: $e');
    }
  }

  void _showEditDialog(UserModel user) {
    String selectedRole = user.role;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text('Chỉnh sửa thông tin User', style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _readOnlyField('Tên người dùng', user.name),
                _readOnlyField('Email', user.email),
                _readOnlyField('Số điện thoại', user.phone ?? 'Chưa cập nhật'),
                _readOnlyField('Ngày sinh', user.dateOfBirth ?? 'Chưa cập nhật'),
                const SizedBox(height: 16),
                const Text('Vai trò (Role)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  dropdownColor: const Color(0xFF1E1E1E),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  initialValue: selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'user', child: Text('USER')),
                    DropdownMenuItem(value: 'admin', child: Text('ADMIN')),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => selectedRole = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (selectedRole != user.role) {
                  _updateRole(user.id, user.name, selectedRole);
                }
              },
              child: const Text('Lưu', style: TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _readOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 15)),
        const Divider(color: Colors.white10),
      ],
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        title: const Text('Quản Lý Người Dùng', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadUsers),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _users.isEmpty
              ? const Center(child: Text('Chưa có người dùng nào', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (_, i) {
                    final user = _users[i];
                    return UserListTile(
                      user: user,
                      onEdit: () => _showEditDialog(user),
                      onToggleRole: () => _toggleRole(user),
                    );
                  },
                ),
    );
  }
}
