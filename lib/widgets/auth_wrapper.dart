import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/domain/authentication.dart';
import 'package:instagram_clone/screens/main_screen.dart';
import 'package:instagram_clone/screens/signup_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateStreamProvider);
    return user.value != null ? const MainScreen() : const SignUpScreen();
  }
}
