import 'package:flutter/material.dart';
import 'package:tecnoanjos_franquia/app/modules/default_page/default_page_widget.dart';

import 'package:tecnoanjos_franquia/app/modules/tecno/model/profile.dart';
import 'package:tecnoanjos_franquia/app/modules/tecno/page/widget/tecno_registration_page_widget.dart';



class TecnoRegistrationPage extends StatefulWidget {
  final Profile profile;

  const TecnoRegistrationPage(this.profile);


  @override
  _TecnoRegistrationPageState createState() =>
      _TecnoRegistrationPageState();
}

class _TecnoRegistrationPageState extends State<TecnoRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultPageWidget(
      childMobile: TecnoRegistrationPageWidget(profile: widget.profile,),
      childWeb: TecnoRegistrationPageWidget(profile: widget.profile,),
    );
  }
}
