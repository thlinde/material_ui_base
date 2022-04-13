// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import '../widgets/page_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          makeHeader(title),
        ],
      ),
    );
  }
}
