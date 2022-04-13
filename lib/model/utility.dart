// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NavItem {
  int index;
  String title;
  IconData icon;
  bool isSelected;
  NavItem(this.index, this.title, this.icon, {this.isSelected = false});
}

List<NavItem> initNavList() {
  List<NavItem> _list = [];
  _list.add(NavItem(0, 'Das ist Item1', Icons.home));
  _list.add(NavItem(1, 'Das ist Item2', Icons.person));
  _list.add(NavItem(2, 'Das ist Item3', Icons.document_scanner));
  return _list;
}

todayDate() => DateFormat('dd.MM.yyyy').format(DateTime.now());