import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'hashtagview.dart';

class HashtagText extends StatelessWidget {
  final String text;

  const HashtagText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textspan = [];

    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textspan.add(
          TextSpan(
              text: '$element ',
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, HashtagView.route(element));
                }),
        );
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textspan.add(
          TextSpan(
            text: '$element ',
            style: const TextStyle(color: Colors.blue, fontSize: 16),
          ),
        );
      } else {
        textspan.add(TextSpan(
          text: '$element ',
          style: const TextStyle(
            fontSize: 18,
          ),
        ));
      }
    });
    return RichText(text: TextSpan(children: textspan));
  }
}
