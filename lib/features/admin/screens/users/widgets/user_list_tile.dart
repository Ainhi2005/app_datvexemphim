import 'package:flutter/material.dart';
import 'package:tet/data/models/user_model.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onEdit;
  final VoidCallback onToggleRole;

  const UserListTile({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onToggleRole,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = user.role == 'admin';

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isAdmin ? Colors.amber : Colors.blueGrey,
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(user.name, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        '${user.email} - Vai trò: ${user.role.toUpperCase()}',
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blueAccent),
            onPressed: onEdit,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAdmin ? Colors.grey : Colors.amber,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: onToggleRole,
            child: Text(
              isAdmin ? 'Hạ quyền' : 'Thăng cấp',
              style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
