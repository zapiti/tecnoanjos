import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';
import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/components/select/select_services_work.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../calling_bloc.dart';

class SelectServicesPage extends StatefulWidget {
  @override
  _SelectServicesPageState createState() => _SelectServicesPageState();
}

class _SelectServicesPageState extends State<SelectServicesPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final callingBloc = Modular.get<CallingBloc>();
  List<ServiceProd> formValue = [];
  AutoScrollController controller;
  TabController _tabController;
  var errorText;
  bool hasError = false;
  List value = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callingBloc.getListService();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);

    _tabController = TabController(
      vsync: this,
      length: 2,
    );

    _tabController.addListener(() async {
      await controller.scrollToIndex(_tabController.index,
          preferPosition: AutoScrollPosition.begin);
      controller.highlight(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SERVIÇOS",
          style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
        ),
        centerTitle: true,
        backgroundColor: AppThemeUtils.colorPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: AppThemeUtils.whiteColor),
      ),
      body: StreamBuilder<List<ServiceProd>>(
          initialData: [],
          stream: callingBloc.listServicesSelectedSubject,
          builder: (context, snapshot) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 10),
                      child: Text(
                        "Selecione aqui o serviço desejado",
                        textAlign: TextAlign.left,
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.colorPrimary, fontSize: 16),
                      )),
                  lineViewWidget(),
                  TabBar(
                    controller: _tabController,
                    labelColor: AppThemeUtils.colorPrimary,
                    unselectedLabelColor: AppThemeUtils.darkGrey,
                    tabs: [
                      Tab(
                        text: 'Presenciais',
                      ),
                      Tab(text: 'Remotos'),
                      // Tab(text: 'Híbridos'),
                    ],
                  ),
                  Expanded(
                      child: StreamBuilder<List<Pairs>>(
                          stream: callingBloc.listServicesSubject,
                          builder: (context, snapshot) => snapshot.data == null
                              ? loadElements(context)
                              : Container(
                                  height: MediaQuery.of(context).size.height,

                                  child: ListView.builder(
                                    controller: controller,
                                    shrinkWrap: true,
                                    itemCount: 2,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.all(8),
                                        child: _getRow(
                                            index, snapshot.data[index]),
                                      );
                                    },
                                  ),
                                  // ChipsChoice<ServiceProd>.multiple(
                                  //   value: state.value,
                                  //   onChanged: (val) => state.didChange(val),
                                  //   choiceItems:
                                  //   C2Choice.listFrom<ServiceProd, ServiceProd>(
                                  //     source: snapshot.data,
                                  //     value: (i, v) => v,
                                  //     label: (i, v) =>
                                  //     "${v.name} (${MoneyMaskedTextController(leftSymbol: "R\$", initialValue: v.price).text})",
                                  //   ),
                                  //   choiceStyle: C2ChoiceStyle(
                                  //     color: AppThemeUtils.colorPrimary,
                                  //     borderOpacity: .3,
                                  //   ),
                                  //   choiceActiveStyle: C2ChoiceStyle(
                                  //     color: AppThemeUtils.colorPrimary,
                                  //     brightness: Brightness.dark,
                                  //   ),
                                  //   wrapped: true,
                                  // ),
                                ))),
                  lineViewWidget(),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data.isEmpty
                                    ? ""
                                    : "${snapshot.data.length}".toString() +
                                        ' selecionados',
                                style: AppThemeUtils.normalSize(
                                    color: hasError
                                        ? AppThemeUtils.colorGrayLight
                                        : AppThemeUtils.darkGrey),
                              ))),
                      errorText != null
                          ? SizedBox()
                          : Expanded(
                              child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Total: ${MoneyMaskedTextController(leftSymbol: "R\$",
                                        initialValue: snapshot.data?.fold(0, (previousValue, element) =>
                                        element.price + previousValue) ?? 0).text}",
                                    style: AppThemeUtils.normalBoldSize(
                                        color: AppThemeUtils.colorPrimary),
                                    textAlign: TextAlign.end,
                                  ))),
                    ],
                  ),
                  lineViewWidget(),
                  Container(
                      margin: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: snapshot.data.isEmpty
                            ? null
                            : () {
                                // callingBloc
                                //     .listServicesSelectedSubject
                                //     .sink
                                //     .add(state.value);
                                Modular.to.pushNamed(
                                    ConstantsRoutes
                                        .CALLING +
                                        ConstantsRoutes
                                            .CREATEATTENDANCE);
                              },
                        style: ElevatedButton.styleFrom(
                            primary: errorText != null
                                ? AppThemeUtils.darkGrey
                                : AppThemeUtils.colorPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                                side: BorderSide(
                                    color: AppThemeUtils.colorError))),
                        child: Container(
                            height: 45,
                            child: Center(
                                child: Text(
                              "Confirmar e avançar",
                              style: AppThemeUtils.normalSize(
                                  color: AppThemeUtils.whiteColor),
                            ))),
                      ))
                ],
              )),
    );
  }

  Widget _getRow(int index, Pairs pairs) {
    return Container(
      child: AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: index,
        child: SelectServicesWork(
          elements: pairs,
          selectProdSubject: callingBloc.listServicesSelectedSubject,
        ),
        highlightColor: Colors.black.withOpacity(0.1),
      ),
    );
    // return _wrapScrollTag(
    //     index: index,
    //     child: Container(
    //       padding: EdgeInsets.all(8),
    //       alignment: Alignment.topCenter,
    //       height: height,
    //       decoration: BoxDecoration(
    //           border: Border.all(color: Colors.lightBlue, width: 4),
    //           borderRadius: BorderRadius.circular(12)),
    //       child: Text('index: $index, height: $height'),
    //     ));
  }
}
