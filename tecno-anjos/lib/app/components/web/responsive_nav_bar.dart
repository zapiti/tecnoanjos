import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class ResponsiveNavBar extends StatelessWidget {
  final Widget startItem;
  final List<Widget> navItems;
  final EdgeInsets edgeInsets;
  final Color color;

  ResponsiveNavBar(
      {Key key,
      this.color,
      @required this.edgeInsets,
      @required this.navItems,
      @required this.startItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Container(
              padding: edgeInsets,
              color: AppThemeUtils.colorPrimary,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [startItem, Row(children: navItems)]));
        } else {
          return Container(
              padding: edgeInsets,
              color: AppThemeUtils.colorPrimary,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [startItem, Row(children: navItems)]));
        }
      },
    );
  }
}

class NavItem extends StatelessWidget {
  final Widget item;
  final double padding;
  final VoidCallback onTap;

  NavItem({Key key, this.item, this.padding, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20), child: item));
  }
}
