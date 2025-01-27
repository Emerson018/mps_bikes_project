import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mps_app/common/models/user_model.dart';

import '../mock/mock_classes.dart';

void main() {
  late MockFirebaseAuthService mockFireBaseAuthService;
  late UserModel user;
  setUp(
    () {
      mockFireBaseAuthService = MockFirebaseAuthService();
      user = UserModel(
        name:'User',
        email: 'user@gmail.com',
        password: 'user@123',
      );
    }
  );

  group(
    'Tests sign up',
    () {
      test(
        'Test SignUp success', () async {
          when(
            ()=> mockFireBaseAuthService.signUp(
              name:'User',
              email: 'user@gmail.com',
              password: 'user@123',
            )
          ).thenAnswer(
            (_) async => user,
          );

          final result = await mockFireBaseAuthService.signUp(
            name:'User',
            email: 'user@gmail.com',
            password: 'user@123',
          );

          expect(
            result, 
            user
          );
        }
      );
      test(
        'Test SignUp failure', () async {
          when(
            ()=> mockFireBaseAuthService.signUp(
              name:'User',
              email: 'user@gmail.com',
              password: 'user@123',
            )
          ).thenThrow(
            Exception(),
          );

          expect(
            ()=> mockFireBaseAuthService.signUp(
              name:'User',
              email: 'user@gmail.com',
              password: 'user@123',
            ),
            //throwsA(isInstanceOf<Exception>()),
            throwsException,
          );
        }
      );
    },
  );
}