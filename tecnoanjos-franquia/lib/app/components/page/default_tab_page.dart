import 'package:auto_size_text/auto_size_text.dart';
import 'package:tecnoanjos_franquia/app/utils/theme/app_theme_utils.dart';
import 'package:flutter/material.dart';

class DefaultTabPage extends StatefulWidget {
  final List<String> Title;

  final List<Widget> Page;
  final EdgeInsets margin;

  DefaultTabPage({
    this.Title,
    this.margin,
    this.Page,
  });

  @override
  _DefaultTabPageState createState() => _DefaultTabPageState();
}

class _DefaultTabPageState extends State<DefaultTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  var index = 0;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: widget.Page.length)
      ..addListener(() {
        setState(() {
          index = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.transparent,
        body: Column(
      children: <Widget>[
        Container(


            child: Row(
            mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,
                children: widget.Title.map<Widget>((e) => Expanded(
                        child:InkWell(
                          onTap: (){
                            _tabController.animateTo(widget.Title.indexOf(e));
                          },
                            child: Column(
                            children: [
                              widget.Title.indexOf(e) == index
                            ? Container(
                            width: double.infinity,
                            height: 2,
                            color: AppThemeUtils.colorPrimary,
                            )
                                : SizedBox(),  Container(
                      color: index == widget.Title.indexOf(e)
                          ? AppThemeUtils.whiteColor
                          : Colors.grey[200],

                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 30),

                        width: double.infinity,
                        child: Align(
                          alignment: widget.Title.indexOf(e) % 2 == 0? Alignment.centerRight : Alignment.centerLeft,
                          child: AutoSizeText(
                            e,
                            maxLines: 2,

                            maxFontSize: 18,
                            style: AppThemeUtils.bigBoldSize(
                              color: index == widget.Title.indexOf(e)
                                  ? AppThemeUtils.iconColor
                                  : Colors.grey[400]
                            ),
                          ),
                        ),
                      ),

                        )])))).toList())),
        Expanded(
            child: TabBarView(

          controller: _tabController,

          children: widget.Page,
        )),
      ],
    ));
  }
}
