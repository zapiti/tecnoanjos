import 'package:flutter/material.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';


class CallToActionTabletDesktop extends StatelessWidget {
  final String title;
  const CallToActionTabletDesktop(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        color: AppThemeUtils.colorPrimary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
