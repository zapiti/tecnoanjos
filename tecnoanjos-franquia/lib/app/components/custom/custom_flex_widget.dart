import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tecnoanjos_franquia/app/utils/utils.dart';



class CustomFlexWidget extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final bool forceSmall;

  CustomFlexWidget(
      {@required this.children, this.crossAxisAlignment, this.forceSmall});

  @override
  Widget build(BuildContext context) {
    bool isSmall = Utils.isSmall(context);

    return Flex(
      direction: (forceSmall ?? isSmall) ? Axis.vertical : Axis.horizontal,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: children
          .map<Widget>((e) => (forceSmall ?? isSmall)
              ? e
              : Expanded(
                  child: e,
                ))
          .toList(),
    );
  }
}
