// lib/features/profile/screens/edit_profile_screen.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  String? _localAvatarPath;

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _localAvatarPath = pickedFile.path;
        });
        if (mounted) SnackbarUtils.showSuccess(context, 'Đã chọn ảnh đại diện mới!');
      }
    } catch (e) {
      if (mounted) SnackbarUtils.showError(context, 'Lỗi khi chọn ảnh: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileProvider>().user;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _dobController.text = user.dateOfBirth ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // === HÀM XỬ LÝ LƯU THÔNG TIN VÀ UPLOAD ẢNH ĐƯỢC TÁCH RA ===
  Future<void> _onSave() async {
    final provider = context.read<ProfileProvider>();
    String? avatarUrl;

    // 1. Nếu người dùng có chọn ảnh mới -> Tiến hành upload trước
    if (_localAvatarPath != null) {
      avatarUrl = await provider.uploadAvatar(_localAvatarPath!);
      
      if (!mounted) return;
      
      // Nếu upload ảnh thất bại (bị lỗi mạng, lỗi server CDN Cloudinary...)
      if (avatarUrl == null) {
        if (provider.error != null) {
          SnackbarUtils.showError(context, provider.error!);
        }
        return; // Dừng tiến trình không lưu thông tin nữa
      }
    }

    // 2. Tiến hành cập nhật thông tin profile kèm theo url ảnh mới (nếu có)
    final success = await provider.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      dob: _dobController.text.trim(),
      avatarUrl: avatarUrl,
    );

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, AppStrings.updateProfileSuccess);
      Navigator.pop(context);
    } else {
      if (provider.error != null) {
        // Bắt lỗi động từ API (Ví dụ: "Số điện thoại đã tồn tại")
        SnackbarUtils.showError(context, provider.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final user = provider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.editProfile, style: AppTextStyles.headlineMedium),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.surface,
                      backgroundImage: _localAvatarPath != null
                          ? FileImage(File(_localAvatarPath!)) as ImageProvider
                          : (user?.avatarUrl != null ? NetworkImage(user!.avatarUrl!) : null),
                      child: _localAvatarPath == null && user?.avatarUrl == null
                          ? const Icon(Icons.person, size: 50, color: AppColors.textSecondary)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, color: AppColors.textButton, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(AppStrings.fullName, Icons.person_outline, _nameController),
            const SizedBox(height: 16),
            _buildTextField(AppStrings.phoneNumber, Icons.phone_outlined, _phoneController),
            const SizedBox(height: 16),
            _buildTextField(
              AppStrings.dateOfBirth,
              Icons.calendar_today_outlined,
              _dobController,
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                // GỌI HÀM VỪA TÁCH
                onPressed: provider.isLoading ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: provider.isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                    : Text(
                        AppStrings.saveChanges,
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textButton, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.background,
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surface, width: 1)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondary, width: 1)),
      ),
    );
  }
}