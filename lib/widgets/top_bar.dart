// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox (
      height: 60,
      child: Ink(
        color: Colors.grey[700],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16.0,
            ),
            Ink(
              decoration: ShapeDecoration(
                shape: const CircleBorder(),
                color: Colors.blue[600],
              ),
              child: IconButton(
                onPressed: () {},
                // iconSize: 25,
                splashRadius: 20,
                icon: Icon(
                  Icons.person_add,
                  color: Colors.grey[100],
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}