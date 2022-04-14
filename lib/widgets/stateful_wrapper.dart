import 'package:flutter/material.dart';

class StatefulWrapper extends StatefulWidget {

  final Function onInit;
  final Function onDispose;
  final Widget chid;

  const StatefulWrapper({
    Key? key,
    required this.onInit,
    required this.onDispose,
    required this.chid
  }) : super(key: key);

  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

class _StatefulWrapperState extends State<StatefulWrapper> {

  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override void dispose() {
    widget.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.chid;
  }
}
