import 'package:flutter/material.dart';

class RoundedCheck extends StatefulWidget {
  @override
  _RoundedCheckState createState() => _RoundedCheckState();
}

class _RoundedCheckState extends State<RoundedCheck> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      child: Center(
          child: InkWell(
        onTap: () {
          setState(() {
            _value = !_value;
          });
        },
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: _value
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  color: Colors.blue,
                ),
        ),
      )),
    );
  }
}
