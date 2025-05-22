import 'package:flutter/material.dart';

class TwoOptionDialog extends StatelessWidget {
  final String title;
  final String content;
  final String firstOptionText;
  final String secondOptionText;
  final void Function()? onFirstOptionPressed;
  final void Function()? onSecondOptionPressed;

  const TwoOptionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.firstOptionText,
    this.onFirstOptionPressed,
    required this.secondOptionText,
    this.onSecondOptionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextTheme.of(context).titleLarge,
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            if (onFirstOptionPressed != null) {
              onFirstOptionPressed!();
            }
            Navigator.of(context).pop();
          },
          child: Text(firstOptionText),
        ),
        TextButton(
          onPressed: () {
            if (onSecondOptionPressed != null) {
              onSecondOptionPressed!();
            }
            Navigator.of(context).pop();
          },
          child: Text(secondOptionText),
        ),
      ],
    );
  }
}
