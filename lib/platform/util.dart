import 'package:flutter/material.dart';

void exitWidget(BuildContext context) => WidgetsBinding.instance
    .addPostFrameCallback((_) => Navigator.of(context).pop());
