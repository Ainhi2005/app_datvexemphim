// lib/features/profile/screens/edit_profile_screen.dart
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:tet/core/l10n/app_localizations.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../providers/profile_provider.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/profile_text_field.dart';

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

  Future<void> _onSave() async {
    final provider = context.read<ProfileProvider>();
    String? avatarUrl;

    if (_localAvatarPath != null) {
      avatarUrl = await provider.uploadAvatar(_localAvatarPath!);
      if (!mounted) return;
      if (avatarUrl == null) {
        if (provider.error != null) SnackbarUtils.showError(context, provider.error!);
        return;
      }
    }

    final success = await provider.updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      dob: _dobController.text.trim(),
      avatarUrl: avatarUrl,
    );

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, AppLocalizations.of(context)!.profile_update_success);
      Navigator.pop(context);
    } else {
      if (provider.error != null) SnackbarUtils.showError(context, provider.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final provider = context.watch<ProfileProvider>();
    final user = provider.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(lang.profile_edit_profile, style: AppTextStyles.headlineMedium),
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
            AvatarPicker(
              localAvatarPath: _localAvatarPath,
              networkAvatarUrl: user?.avatarUrl,
              onTap: _pickImage,
            ),
            const SizedBox(height: 32),
            ProfileTextField(
              label: lang.profile_full_name,
              icon: Icons.person_outline,
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            ProfileTextField(
              label: lang.profile_phone_number,
              icon: Icons.phone_outlined,
              controller: _phoneController,
            ),
            const SizedBox(height: 16),
            ProfileTextField(
              label: lang.profile_date_of_birth,
              icon: Icons.calendar_today_outlined,
              controller: _dobController,
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
                    _dobController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: provider.isLoading ? null : _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: provider.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                      )
                    : Text(
                        lang.profile_save_changes,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textButton,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}