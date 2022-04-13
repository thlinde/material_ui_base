// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

makeHeader(String title) => SizedBox(
  height: 50,
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade700,
        ),
      ),
    ],
  ),
);

class PageHeader extends StatelessWidget {
  const PageHeader({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
