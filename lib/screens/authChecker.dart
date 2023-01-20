import 'package:train_inquiry/screens/errorScreen.dart';
import 'package:train_inquiry/screens/loadingScreen.dart';
import 'package:train_inquiry/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'loginScreen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
        data: (data) {
          if (data != null) {return HomeRoute();}
        },
        loading: () => const LoadingScreen(),
        error: (e, trace) => ErrorScreen());
  }
}