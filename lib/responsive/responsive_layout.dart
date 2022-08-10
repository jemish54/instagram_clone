import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/dimensions.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget? webLayout;

  const ResponsiveLayout({Key? key, required this.mobileLayout, this.webLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: ((context, constraints) =>
            constraints.maxWidth > webScreenBreakpoint
                ? webLayout ?? mobileLayout
                : mobileLayout));
  }
}
