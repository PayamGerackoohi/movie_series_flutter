import 'dart:async';

import 'package:flutter/material.dart';

class DelayedPop extends StatefulWidget {
  const DelayedPop({this.time = const Duration(seconds: 1), super.key});

  final Duration time;

  @override
  State<StatefulWidget> createState() => _DelayedPopState();
}

class _DelayedPopState extends State<DelayedPop> {
  Timer? timer;
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timer = Timer(widget.time, () => _navigator.pop());
    return const SizedBox.shrink();
  }
}
