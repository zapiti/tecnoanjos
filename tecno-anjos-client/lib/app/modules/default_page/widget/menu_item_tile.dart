import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
class MenuItemTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  const MenuItemTile({
    Key key,
    @required this.title,
    @required this.icon,
    this.animationController,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  _MenuItemTileState createState() => _MenuItemTileState();
}

class _MenuItemTileState extends State<MenuItemTile> {
  Animation<double> _animation, _sizedBoxAnimation;

  double minWidth = 100;

  @override
  void initState() {
    super.initState();
    _animation =
        Tween<double>(begin: 250, end: 100).animate(widget.animationController);
    _sizedBoxAnimation =
        Tween<double>(begin: 10, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        color: widget.isSelected
            ? AppThemeUtils.colorPrimary
            : Colors.transparent,

        child: InkWell(
            onTap: widget.onTap,
            child: Column(
              children: [
                Container(
                  color: widget.isSelected
                      ? AppThemeUtils.colorPrimary
                      : Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  width: Utils.isSmall(context) ? minWidth : _animation.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        widget.icon,
                        color: widget.isSelected
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                      ),

                      SizedBox(
                        width:
                        Utils.isSmall(context) ? 0 : _sizedBoxAnimation.value,
                      ),
                      if ((Utils.isSmall(context) ? minWidth : _animation.value) >=
                          200)
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                child: AutoSizeText(
                                  widget.title,
                                  style: widget.isSelected
                                      ? AppThemeUtils.normalBoldSize(
                                      color: widget.isSelected
                                          ? Colors.white
                                          : AppThemeUtils.colorPrimary,
                                      fontSize: 14)
                                      : AppThemeUtils.normalBoldSize(
                                      color: widget.isSelected
                                          ? Colors.white
                                          : AppThemeUtils.colorPrimary,
                                      fontSize: 14),
                                  maxLines: 1,
                                  minFontSize: 10,
                                ))),
                    ],
                  ),
                ),
                _animation.value > 100 ? SizedBox() :    Container(
                    padding: EdgeInsets.only(bottom: 10,right: 5,left: 5),

                    child: AutoSizeText( widget.title,maxLines: 2,minFontSize: 8, textAlign: TextAlign.center,
                        style:AppThemeUtils.normalBoldSize(
                            color: widget.isSelected
                                ? Colors.white
                                : AppThemeUtils.colorPrimary,
                            fontSize: 10))
                ),
                lineViewWidget()
              ],
            )));
  }
}
