import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mps_app/common/models/user_model.dart';
import 'package:mps_app/features/sign_up/sign_up_controller.dart';
import 'package:mps_app/features/sign_up/sign_up_state.dart';

import '../../mock/mock_classes.dart';

void main() {
  late SignUpController signUpController;
  late MockSecureStorage mockSecureStorage;
  late MockFirebaseAuthService mockFirebaseAuthService;
  late UserModel user;
  setUp(() {
    mockFirebaseAuthService = MockFirebaseAuthService();
    mockSecureStorage = MockSecureStorage();
    
    signUpController = SignUpController(
      mockFirebaseAuthService,
      mockSecureStorage
    );
    user = UserModel(
        name:'User',
        email: 'user@gmail.com',
        password: 'user@123',
      );
  });

  test('Tests SignUp Controller Success State', () async {
  expect(signUpController.state, isInstanceOf<SignUpInitialState>());
  when(
    () => mockFirebaseAuthService.signUp(
      name: any(named: 'name'),
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  ).thenAnswer((_) async => UserModel(
        id: '123', // ID não nulo
        name: 'User',
        email: 'user@gmail.com',
        password: 'user@123',
      ));

  when(
    () => mockSecureStorage.write(
      key: 'CURRENT_USER',
      value: json.encode({
        'id': '123',
        'name': 'User',
        'email': 'user@gmail.com',
        'password': 'user@123',
      }),
    ),
  ).thenAnswer((_) async {});

  await signUpController.signUp(
    name: 'User',
    email: 'user@gmail.com',
    password: 'user@123',
  );

  expect(signUpController.state, isInstanceOf<SignUpSuccessState>());
});
//AQUI SÓ FUNCIONOU COM A RESPOSTA DO CHATGPT:
//https://chatgpt.com/c/6797ec40-5d3c-8009-935f-cee52c605e56

  test('Tests Sign Up Controller Error State', () async {
    expect(signUpController.state, isInstanceOf<SignUpInitialState>());
    when(
      () => mockSecureStorage.write(
        key: "CURRENT_USER",
        value: user.toJson(),
      ),
    ).thenAnswer((_) async {});
    when(
      () => mockFirebaseAuthService.signUp(
        name: 'User',
        email: 'user@email.com',
        password: 'user@123',
      ),
    ).thenThrow(
      Exception(),
    );
    await signUpController.signUp(
      name: 'User',
      email: 'user@email.com',
      password: 'user@123',
    );
    expect(signUpController.state, isInstanceOf<SignUpErrorState>());
  });
}