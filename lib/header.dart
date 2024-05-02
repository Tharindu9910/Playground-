import 'package:flutter/material.dart';
import 'theme.dart';

class Header extends AppBar {
  Header({super.key})
      : super(
          title: const Text('PlayGround'),
          backgroundColor: AppTheme.primaryColor,
          titleTextStyle: const TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        );
}
