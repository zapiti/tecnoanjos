
import 'package:flutter/material.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_landingpage_file.dart';


import 'widget/call_to_action/call_to_action.dart';
import 'widget/course_details/course_details.dart';

class HomeContentMobile extends StatelessWidget {
  const HomeContentMobile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CourseDetails(),
        SizedBox(
          height: 100,
        ),
        CallToAction(StringLandingPageFile.sejaParceiro),
      ],
    );
  }
}
