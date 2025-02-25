import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/extensions/sizes.dart';
import 'package:mps_app/common/widgets/custom_text_form_field.dart';
import '../profile_controller.dart';

class ProfileChangeNameWidget extends StatefulWidget {
  final ProfileController profileController;

  const ProfileChangeNameWidget({
    Key? key,
    required this.profileController,
  }) : super(key: key);

  @override
  State<ProfileChangeNameWidget> createState() => _ProfileChangeNameWidgetState();
}

class _ProfileChangeNameWidgetState extends State<ProfileChangeNameWidget> {
  final TextEditingController _nameController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _nameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = _nameController.text.trim().isNotEmpty;
    });
  }

  Future<void> _saveNewName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      await widget.profileController.updateUserName(newName);
      widget.profileController.toggleChangeName(); // Fecha o widget após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('change-name-widget'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Change Name',
          style: AppTextStyles.mediumText20.apply(color: AppColors.darkGrey),
        ),
        SizedBox(height: 24.h),
        
        /// Campo de texto para inserir o novo nome
        CustomTextFormField(
          labelText: 'New Name',
          controller: _nameController,
          onChanged: (value) => _updateButtonState(),
        ),
        SizedBox(height: 24.h),
        
        /// Botões "Cancel" e "Save"
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenlightOne,
              ),
              onPressed: widget.profileController.toggleChangeName,
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled ? AppColors.greenlightTwo : Colors.grey,
              ),
              onPressed: isButtonEnabled ? _saveNewName : null ,
              
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
