import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final int index;
  const EmptyScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text("$index"))),
    );
  }
}
