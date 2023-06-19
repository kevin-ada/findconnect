import 'package:findmychild/components/buttons.dart';
import 'package:findmychild/components/loading_page.dart';
import 'package:findmychild/components/textfield.dart';
import 'package:findmychild/controller/auth_controller.dart';
import 'package:findmychild/screens/sign_in.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Sign_up extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const Sign_up());

  const Sign_up({Key? key}) : super(key: key);

  @override
  ConsumerState<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends ConsumerState<Sign_up> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void onSignUp() {
    ref.read(authControllerProvider.notifier).signUp(
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
          "SIGN UP",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  textAlign: TextAlign.center,
                  "A community Dedicated To Find Your Loved One",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 10),
                Textfield_reusable(
                    controller: emailcontroller,
                    hintText: 'Email',
                    obscureText: false),
                const SizedBox(height: 20),
                Textfield_reusable(
                    controller: passwordcontroller,
                    hintText: 'Password',
                    obscureText: true),
                const SizedBox(height: 20),
                Mybutton(
                    ontap: () {
                      onSignUp();
                    },
                    text: 'Sign Up'),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                      text: 'Already Have an Account? ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Login_view()));
                              })
                      ]),
                )
              ],
            ),
    );
  }
}
