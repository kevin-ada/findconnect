import 'package:flutter/material.dart';

class TweetIconButton extends StatelessWidget {
  final IconData path;
  final String text;
  final VoidCallback onTap;
  const TweetIconButton(
      {super.key, required this.path, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            path,
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.all(6),
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
