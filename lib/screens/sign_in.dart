import 'package:findmychild/components/buttons.dart';
import 'package:findmychild/components/textfield.dart';
import 'package:findmychild/screens/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/loading_page.dart';
import '../controller/auth_controller.dart';

class Login_view extends ConsumerStatefulWidget {
  const Login_view({Key? key}) : super(key: key);

  @override
  ConsumerState<Login_view> createState() => _Sign_InState();
}

class _Sign_InState extends ConsumerState<Login_view> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void onSignIn() {
    ref.read(authControllerProvider.notifier).SignIn(
        email: emailcontroller.text,
        password: passwordcontroller.text,
        context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xff2B2730),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff2B2730),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "SIGN IN",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "A community Dedicated To Find Your Loved One",
                  style: TextStyle(color: Colors.white),
                ),
                Textfield_reusable(
                    controller: emailcontroller,
                    hintText: 'Email',
                    obscureText: false),
                const SizedBox(height: 20),
                Textfield_reusable(
                    controller: passwordcontroller,
                    hintText: 'Password',
                    obscureText: true),
                SizedBox(height: 20),
                Mybutton(
                    ontap: () {
                      onSignIn();
                    },
                    text: 'Sign In'),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                      text: 'Do Not Have an Account? ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                            text: 'Sign up',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Sign_up()));
                              })
                      ]),
                )
              ],
            ),
    );
  }
}
