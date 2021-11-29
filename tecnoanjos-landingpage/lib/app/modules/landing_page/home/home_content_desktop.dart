import 'package:flutter/material.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_file.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_landingpage_file.dart';

import 'widget/call_to_action/call_to_action.dart';
import 'widget/course_details/course_details.dart';

class HomeContentDesktop extends StatelessWidget {
  const HomeContentDesktop({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CourseDetails(),
        Expanded(
          child: Center(
            child: CallToAction(StringLandingPageFile.sejaParceiro),
          ),
        )
      ],
    );
  }
}
