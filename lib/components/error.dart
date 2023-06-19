import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String error;
  const Error({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}

class Errorpage extends StatelessWidget {
  final String error;
  const Errorpage({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Error(
        error: '$error',
      ),
    );
  }
}

