import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:tecnoanjostec/app/utils/theme/app_theme_utils.dart';

class DefaultTabPage extends StatefulWidget {
  final List<String> title;
  final List<Widget> page;
  final dynamic neverScroll;
  final Function(TabController) changeTab;

  DefaultTabPage({this.title, this.page, this.neverScroll, this.changeTab});

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
    _tabController = new TabController(vsync: this, length: widget.page.length)
      ..addListener(() {
        setState(() {
          index = _tabController.index;
        });
      });

    if (widget.changeTab != null) {
      widget.changeTab(_tabController);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
                children: widget.title
                    .map<Widget>((e) => Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: index == widget.title.indexOf(e)
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  side: BorderSide(
                                      color: index == widget.title.indexOf(e)
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).primaryColor,
                                      width: 1)),
                            ),
                            onPressed: () {
                              _tabController.animateTo(widget.title.indexOf(e));
                            },
                            child: Container(
                              height: 40,
                              child: Center(
                                child: AutoSizeText(
                                  e,
                                  maxLines: 2,
                                  minFontSize: 12,
                                  maxFontSize: 13,
                                  textAlign: TextAlign.center,
                                  style: AppThemeUtils.normalSize(
                                      color: index == widget.title.indexOf(e)
                                          ? Colors.white
                                          : Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))))
                    .toList())),
        Flexible(
            child: TabBarView(
          physics: widget.neverScroll ?? ClampingScrollPhysics(),
          controller: _tabController,
          children: widget.page,
        )),
      ],
    ));
  }
}
