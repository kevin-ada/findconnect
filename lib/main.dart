import 'package:findconnect/screens/home.dart';
import 'package:findconnect/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/error.dart';
import 'components/loading_page.dart';
import 'controller/auth_controller.dart';

void main() {
  runApp(
    const ProviderScope(child: Findmychild()),
  );
}

class Findmychild extends ConsumerWidget {
  const Findmychild({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ref.watch(CurrentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return Home();
              }
              return const Sign_up();
            },
            error: (e, st) => Errorpage(error: e.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
