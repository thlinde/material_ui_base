// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_ui_base/model/store.dart';

class TopBar extends StatelessWidget {
  TopBar({Key? key}) : super(key: key);

  final controller = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Ink(
        color: Colors.grey.shade700,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.only(left: 16)),
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
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16)),
            Text(
              '',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade100
              ),
            ),
            const Expanded(child: SizedBox()),
            Obx(() =>
                Text(
                  controller.todayStr.value,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade100
                  ),
                ),
            ),
            const Padding(padding: EdgeInsets.only(right: 16)),
          ],
        ),
      ),
    );
  }
}