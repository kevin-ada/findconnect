import 'package:flutter/material.dart';

class PostContainer extends StatelessWidget {
  final String text;
  final GestureTapCallback? ontap;
  const PostContainer({super.key, required this.text, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      height: 45,
      width: 100,
      decoration: BoxDecoration(
          color: const Color(0xff967E76),
          borderRadius: BorderRadius.circular(16)),
      child: Text(text),
    );
  }
}
