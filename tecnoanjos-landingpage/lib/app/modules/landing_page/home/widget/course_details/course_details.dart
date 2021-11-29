import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Container(
          width: 600,
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Text(
          //       'TECNOANJO',
          //       style: TextStyle(
          //           fontWeight: FontWeight.w800,
          //           height: 0.9,
          //           fontSize: titleSize),
          //       textAlign: textAlignment,
          //     ),
          //     SizedBox(
          //       height: 30,
          //     ),
          //     Text(
          //       'CONHEÇA NOSSOS PRODUTOS E SEJA PARCEIRO DA NOSSA FORMA DE APRESENTAR ENTREGA DE SERVICOS',
          //       style: TextStyle(
          //         fontSize: descriptionSize,
          //         height: 1.7,
          //       ),
          //       textAlign: textAlignment,
          //     )
          //   ],
          // ),
        );
      },
    );
  }
}
