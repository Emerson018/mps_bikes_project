import 'package:mps_app/common/models/user_model.dart';

abstract class ProfileState {}

class ProfileStateInitial extends ProfileState {}

class ProfileStateLoading extends ProfileState {}

class ProfileStateSuccess extends ProfileState {
  ProfileStateSuccess({this.user});

  final UserModel? user;
}

class ProfileStateError extends ProfileState {
  ProfileStateError({required this.message});

  final String message;
}