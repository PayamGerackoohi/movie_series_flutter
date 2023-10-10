import 'package:flutter/material.dart';
import 'package:movie_series/view/widget/delayed_pop.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(this.error, {super.key});

  final String error;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                error,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const DelayedPop(),
        ],
      );
}

void showErrorDialog(BuildContext context, {required String error}) =>
    showModalBottomSheet(context: context, builder: (_) => ErrorDialog(error));
