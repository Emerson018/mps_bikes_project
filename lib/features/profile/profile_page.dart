import 'package:flutter/material.dart';
import 'package:mps_app/common/constants/app_colors.dart';
import 'package:mps_app/common/constants/app_text_style.dart';
import 'package:mps_app/common/extensions/sizes.dart';
import 'package:mps_app/common/widgets/app_header.dart';
import 'package:mps_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:mps_app/common/widgets/custom_snackbar.dart';
import 'package:mps_app/services/auth_service.dart';
import 'package:mps_app/services/secure_storage.dart';
import '../../locator.dart';
import 'profile_controller.dart';
import 'profile_state.dart';
import 'widgets/profile_change_name_widget.dart';
import 'widgets/profile_change_password_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with CustomSnackBar {
  final _profileController = locator.get<ProfileController>();

  @override
  void initState() {
    super.initState();
    _profileController.getUserData();
    _profileController.addListener(_handleProfileStateChange);
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  void _handleProfileStateChange() {
    final state = (_profileController.state);

    if (!mounted) return;

    switch (state.runtimeType) {
      case ProfileStateError:
        if (!mounted) return;

        if (_profileController.showChangeName ||
            _profileController.showChangePassword) {
          showCustomSnackBar(
            context: context,
            text: (_profileController.state as ProfileStateError).message,
            type: SnackBarType.error,
          );
        }
        break;

      case ProfileStateSuccess:
        if (_profileController.showNameUpdateMessage) {
          showCustomSnackBar(
            context: context,
            text: 'Nome de usuário atualizado com sucesso',
            type: SnackBarType.success,
          );
        }
        if (_profileController.showPasswordUpdateMessage) {
          showCustomSnackBar(
            context: context,
            text: 'Senha alterada com sucesso',
            type: SnackBarType.success,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const AppHeader(),
          Positioned(
            top: 210.h,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  minRadius: 60.h,
                  backgroundColor: AppColors.greenlightTwo,
                  child: const Icon(
                    Icons.person,
                    color: AppColors.iceWhite,
                  ),
                ),
                SizedBox(height: 20.h),
                AnimatedBuilder(
                  animation: _profileController,
                  builder: (context, child) {
                    if (_profileController.state is ProfileStateLoading) {
                      return const CustomCircularProgressIndicator(
                          color: AppColors.green);
                    }
                    return Column(
                      children: [
                        Text(
                          (_profileController.userData.name ?? 'sem nome'),
                          style: AppTextStyles.mediumText20.apply(
                            color: AppColors.darkGrey,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          _profileController.userData.email ?? '',
                          style: AppTextStyles.smallText.apply(
                            color: AppColors.greenlightOne,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 450.h,
            left: 32,
            right: 32,
            bottom: 0,
            child: SingleChildScrollView(
              child: ListenableBuilder(
                listenable: _profileController,
                builder: (context, child) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: _profileController.showChangeName
                        ? ProfileChangeNameWidget(
                            key: const ValueKey('change-name'),
                            profileController: _profileController,
                          )
                        : _profileController.showChangePassword
                            ? ProfileChangePasswordWidget(
                                key: const ValueKey('change-password'),
                                profileController: _profileController,
                              )
                            : Column(
                                key: UniqueKey(),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                       _profileController.onChangeNameTapped();
                                    },
                                    icon: const Icon(
                                      Icons.person,
                                      color: AppColors.greenlightTwo,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Alterar nome',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.greenlightTwo),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      _profileController
                                          .onChangePasswordTapped();
                                    },
                                    icon: const Icon(
                                      Icons.lock_person_rounded,
                                      color: AppColors.greenlightTwo,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Alterar senha',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.greenlightTwo),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                    },
                                    icon: const Icon(
                                      Icons.policy,
                                      color: AppColors.greenlightTwo,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Termos de uso',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.greenlightTwo),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: AppColors.greenlightTwo,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Deletar conta',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.greenlightTwo),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async{
                                     await locator.get<AuthService>().signOut();
                                      await const Securestorage().deleteAll();
                                      if (mounted) {
                                        Navigator.popUntil(context, ModalRoute.withName('/'));
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.logout_outlined,
                                      color: AppColors.greenlightTwo,
                                    ),
                                    label: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Sair do app',
                                        style: AppTextStyles.mediumText16w500
                                            .apply(color: AppColors.greenlightTwo),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}