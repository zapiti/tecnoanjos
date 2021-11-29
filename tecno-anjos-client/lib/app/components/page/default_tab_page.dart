import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

// ignore: must_be_immutable
class DefaultTabPage extends StatefulWidget {
  final List<String> title;

  final List<Widget> page;
  final dynamic neverScroll;
  final Function(TabController) changeTab;
  final Function(int) tapIndex;
  final int initialPage;
  TabController tabController;

  DefaultTabPage(this.tabController,
      {this.title,
        this.page,
        this.neverScroll,
        this.changeTab,
        this.initialPage,
        this.tapIndex});

  @override
  _DefaultTabPageState createState() => _DefaultTabPageState();
}

class _DefaultTabPageState extends State<DefaultTabPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  var index = 0;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(
        vsync: this,
        length: widget.page.length,
        initialIndex: widget.initialPage ?? 0)
      ..addListener(() {
        setState(() {
          index = tabController.index;
        });
      });

    if (widget.changeTab != null) {
      widget.tabController = tabController;
      widget.changeTab(tabController);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: Column(
          children: <Widget>[
            Container(

                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Row(
                    children: widget.title
                        .map<Widget>((e) =>
                        Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: index == widget.title.indexOf(e)
                                      ? Theme
                                      .of(context)
                                      .primaryColor
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                      side: BorderSide(
                                          color: index ==
                                              widget.title.indexOf(e)
                                              ? Theme
                                              .of(context)
                                              .primaryColor
                                              : Theme
                                              .of(context)
                                              .primaryColor,
                                          width: 1))),

                              onPressed: () {
                                if (widget.tapIndex != null) {
                                  widget.tapIndex(widget.title.indexOf(e));
                                }
                                tabController.animateTo(widget.title.indexOf(
                                    e));
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
                                            : Theme
                                            .of(context)
                                            .primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )))
                        .toList())),
            Flexible(
                child: TabBarView(
                  physics: widget.neverScroll ?? ClampingScrollPhysics(),
                  controller: tabController,
                  children: widget.page,
                )),
          ],
        ));
  }
}
