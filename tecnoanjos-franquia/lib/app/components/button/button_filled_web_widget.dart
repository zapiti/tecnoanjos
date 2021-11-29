import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';



class ButtonFilledWebWidget extends StatelessWidget {
  ButtonFilledWebWidget(
      {@required this.text, this.onPressed, this.color, this.icon});

  final String text;
  final VoidCallback onPressed;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: RaisedButton(
        padding: EdgeInsets.all(16),
        color: color ?? AppThemeUtils.colorPrimary,
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
        },
        child: icon != null
            ? Icon(icon, color: Colors.white,)
            : Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none),
      ),
    );
  }
}
