import 'dart:io';
import 'package:assignment/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authrepositoryProvider);
  return AuthController(
    authRepository: authRepository,
    ref: ref,
  );
});
final getuserDataControllerProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.authRepository.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });
  void registerUser({required String email, required String password}) async {
    authRepository.registerUser(email: email, password: password);
  }

  void loginUser({required String email, required String password}) async {
    authRepository.loginUser(email: email, password: password);
  }

  void signOut(BuildContext context) async {
    authRepository.signOut(context);
  }

  void saveUserData({
    required String name,
    required String email,
    required File? profilePic,
    required BuildContext context,
  }) async {
    authRepository.saveUserData(
      name: name,
      email: email,
      profilePic: profilePic!,
      ref: ref,
      context: context,
    );
  }
}
