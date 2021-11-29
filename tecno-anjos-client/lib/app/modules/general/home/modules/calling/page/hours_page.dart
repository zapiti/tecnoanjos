import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/components/dialog/date/date_bottom_sheet.dart';
import 'package:tecnoanjosclient/app/components/divider/line_view_widget.dart';

import 'package:tecnoanjosclient/app/components/load/load_elements.dart';
import 'package:tecnoanjosclient/app/components/mobile/title_descritption_mobile_widget.dart';
import 'package:tecnoanjosclient/app/components/select/select_button.dart';

import 'package:tecnoanjosclient/app/components/update_builder.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/calling.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/calling/model/service_prod.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/first_login/first_login.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/pages/widget/myAddress_bottom_sheet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/widget/wallet_bottom_sheet.dart';
import 'package:tecnoanjosclient/app/routes/constants_routes.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/attendance/attendance_utils.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/string/string_extension.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../calling_bloc.dart';

class HoursPage extends StatefulWidget {
  @override
  _HoursPageState createState() => _HoursPageState();
}

class _HoursPageState extends State<HoursPage> {
  final appBloc = Modular.get<AppBloc>();
  final profileBloc = Modular.get<ProfileBloc>();
  var nameController = TextEditingController();
  var quantityController = TextEditingController();
  var moneyController =
      MoneyMaskedTextController(leftSymbol: "R\$", initialValue: 0);
  var callingBloc = Modular.get<CallingBloc>();
  var callLing = Calling();
  String error;
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List.from([]);
  BuildContext myContext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AmplitudeUtil.createEvent(AmplitudeUtil.eventCriarAtendimento(1));
    callingBloc.getCurrentMoney();
    if (callingBloc.myCalling?.stream?.value?.hourAttendance != null) {
      callingBloc.dateController.text = MyDateUtils.parseDateTimeFormat(
          callingBloc.myCalling?.stream?.value?.hourAttendance,
          callingBloc.myCalling?.stream?.value?.hourAttendance,
          format: "dd/MM/yyyy HH:mm");
    }
    if (callingBloc.myCalling?.stream?.value?.description != null) {
      callingBloc.controllerObs.text =
          callingBloc.myCalling?.stream?.value?.description;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      callingBloc.getValueCreated();
      appBloc.getSecondOnBoard(() {
        initTargets();
        showTutorial();
      });
    });
  }

  GlobalKey<FormState> keyB1 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB2 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB3 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB4 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB5 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB6 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB7 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB8 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB9 = GlobalKey<FormState>();
  GlobalKey<FormState> keyB10 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //  var _qualificationBloc = Modular.get<QualificationsBloc>();

    return StreamBuilder(
        stream: appBloc.secondOnboardSubject,
        initialData: false,
        builder: (context, snapshotOnboard) => snapshotOnboard.data
            ? SecondOnboard()
            : StreamBuilder<List<ServiceProd>>(
                stream: callingBloc.listServicesSelectedSubject,
                initialData: [],
                builder: (context, snapshotSelected) => Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          updateBuilder<Calling>(
                              stream: callingBloc.myCalling.stream,
                              initialData: Calling(),
                              builderReturn: (resulted) {
                                callLing = resulted;
                                // callingBloc.dateController.text =
                                //     MyDateUtils.parseDateTimeFormat(
                                //         callLing.hourAttendance, null,
                                //         format: "dd/MM/yyyy HH:mm");
                                // callingBloc.controllerObs.text = callLing.description;
                              }),
                          StreamBuilder<CurrentUser>(
                              stream: appBloc.getCurrentUserFutureValue(),
                              builder: (context, snapshot) => Container(
                                  margin: EdgeInsets.only(
                                      right: 20, left: 20, top: 20, bottom: 0),
                                  child: Text(
                                    "Vamos começar, ${(snapshot?.data?.name ?? "").split(" ").first}?",
                                    textAlign: TextAlign.left,
                                    style: AppThemeUtils.normalSize(
                                        color: AppThemeUtils.colorPrimary,
                                        fontSize: 18),
                                  ))),
                          lineViewWidget(top: 10),
                          Container(
                              margin: EdgeInsets.only(
                                  right: 20, left: 20, top: 5, bottom: 5),
                              child: Text(
                                "Você precisa de ${(snapshotSelected?.data?.map((e) => e.name)?.join(",") ?? "")}",
                                textAlign: TextAlign.left,
                                style: AppThemeUtils.normalSize(
                                    color: AppThemeUtils.black, fontSize: 12),
                              )),
                          lineViewWidget(bottom: 10),
                          AttendanceUtils.isOnlyPresential(
                                  snapshotSelected.data)
                              ? Container(
                                  margin: EdgeInsets.only(
                                      right: 25, left: 25, top: 0, bottom: 5),
                                  child: Text(
                                    "Serviços selecionados só podem ter atendimento presencial",
                                    textAlign: TextAlign.left,
                                    style: AppThemeUtils.normalBoldSize(
                                        color: AppThemeUtils.colorPrimary,
                                        fontSize: 16),
                                  ))
                              : SizedBox(),
                          !AttendanceUtils.isOnlyPresential(
                                  snapshotSelected.data)
                              ? SizedBox()
                              : lineViewWidget(bottom: 10, top: 5),
                          Container(
                              margin: EdgeInsets.only(
                                  right: 20, left: 20, top: 5, bottom: 0),
                              child: Text(
                                StringFile.quandoSerAtendido,
                                textAlign: TextAlign.left,
                                style: AppThemeUtils.normalSize(fontSize: 14),
                              )),
                          StreamBuilder<Calling>(
                              stream: callingBloc.myCalling.stream,
                              builder: (context, snapshot) => snapshot.data ==
                                      null
                                  ? loadElements(context)
                                  : Container(
                                      margin: EdgeInsets.only(
                                          right: 15,
                                          left: 15,
                                          top: 0,
                                          bottom: 5),
                                      child: SelectButton(
                                        key: keyB1,
                                        keys1: keyB2,
                                        keys2: keyB3,
                                        // keys: [keyB2,keyB3],
                                        initialItem: snapshot.data.initHours ==
                                                "-1"
                                            ? null
                                            : snapshot.data.hourAttendance ==
                                                    null
                                                ? 0
                                                : 1,
                                        everyEnable: true,
                                        tapIndex: (i) {
                                          if (i?.first == true) {
                                            callingBloc.selectedDate(null);
                                          } else {
                                            showDateBottomSheet(context,
                                                initialDate: snapshot
                                                    .data.hourAttendance,
                                                onDate: (date) {
                                              Navigator.pop(context);
                                              callingBloc.selectedDate(date);
                                              //
                                              // setState(() {
                                              //
                                              // });
                                            });
                                          }
                                        },
                                        title:
                                            snapshot.data.hourAttendance == null
                                                ? [
                                                    Pairs(true, "Agora"),
                                                    Pairs(false, "Agendar")
                                                  ]
                                                : [
                                                    Pairs(true, "Agora"),
                                                    Pairs(
                                                        false,
                                                        snapshot.data
                                                                    .hourAttendance ==
                                                                null
                                                            ? "Agendar"
                                                            : (MyDateUtils.parseDateTimeFormat(
                                                                    snapshot
                                                                        .data
                                                                        .hourAttendance,
                                                                    snapshot
                                                                        .data
                                                                        .hourAttendance,
                                                                    format:
                                                                        "EE, dd/MM-HH:mm")
                                                                .capitalize())),
                                                  ],
                                      ))),
                          AttendanceUtils.isOnlyPresential(
                                  snapshotSelected.data)
                              ? SizedBox()
                              : Container(
                                  margin: EdgeInsets.only(
                                      right: 20, left: 20, top: 5, bottom: 0),
                                  child: Text(
                                    StringFile.comoSerAtendido,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppThemeUtils.normalSize(fontSize: 14),
                                  )),
                          AttendanceUtils.isOnlyPresential(
                                  snapshotSelected.data)
                              ? SizedBox()
                              : StreamBuilder<Calling>(
                                  stream: callingBloc.myCalling.stream,
                                  builder: (context, snapshot) => snapshot
                                              .data ==
                                          null
                                      ? loadElements(context)
                                      : Container(
                                          margin: EdgeInsets.only(
                                              right: 15,
                                              left: 15,
                                              top: 0,
                                              bottom: 5),
                                          child: SelectButton(
                                            key: keyB4,
                                            keys1: keyB5,
                                            keys2: keyB6,
                                            // keys: [keyB5,keyB6],
                                            initialItem:
                                                snapshot.data.initLocal == "-1"
                                                    ? null
                                                    : snapshot.data.myAddress ==
                                                            null
                                                        ? 1
                                                        : 0,
                                            everyEnable: true,
                                            tapIndex: (i) {
                                              if (i?.first == false) {
                                                callingBloc
                                                    .selectedAddredss(null);
                                              } else {
                                                showBottomSheetMyAddress(
                                                    context, (address) {
                                                  callingBloc.selectedAddredss(
                                                      address);
                                                });

                                                //
                                                // setState(() {
                                                //
                                                // });

                                              }
                                            },
                                            title: [
                                              Pairs(true, "Presencial"),
                                              Pairs(false, "Remoto"),
                                            ],
                                          ))),
                          // lineViewWidget(bottom: 5),
                          // titleDescriptionBigMobileWidget2(context,descrColor: AppThemeUtils.colorPrimary,
                          //     action: () async {
                          //   showBottomSheetServices(context,listServices,
                          //       selected: (listSelected) {
                          //     SchedulerBinding.instance.addPostFrameCallback((_) {
                          //       setState(() {
                          //         listServices = listSelected;
                          //       });
                          //       Navigator.of(context).pop();
                          //     });
                          //   });
                          // },
                          //     padding: 0,
                          //     title: 'Atendimento por hora ou serviços',
                          //     maxLine: 1,
                          //     customIcon: Icon(
                          //       Icons.edit,
                          //       color: Colors.black,
                          //       size: 30,
                          //     ),
                          //     description: listServices.isEmpty
                          //         ? "Atendimento por hora"
                          //         : listServices
                          //             .map<String>((e) => e.nomeProduto)
                          //             .toList()
                          //             .join(",")),
                          // lineViewWidget(top: 5, bottom: 10),
                          Container(
                              margin: EdgeInsets.only(
                                  right: 20, left: 20, top: 5, bottom: 6),
                              child: Text(
                                StringFile.comoPodeTeAjudar,
                                textAlign: TextAlign.left,
                                style: AppThemeUtils.normalSize(fontSize: 14),
                              )),
                          Container(
                              key: keyB7,
                              margin: EdgeInsets.only(
                                  right: 20, left: 20, top: 0, bottom: 0),
                              child: TextField(
                                onChanged: (text) {
                                  callingBloc.selectedText(text);
                                  if (error != null) {
                                    setState(() {
                                      error = null;
                                    });
                                  }
                                },
                                maxLines: 2,
                                controller: callingBloc.controllerObs,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(150),
                                ],
                                decoration: InputDecoration(
                                  errorText: error,
                                  hintStyle: AppThemeUtils.normalSize(),
                                  labelStyle: AppThemeUtils.normalSize(),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppThemeUtils.colorError),
                                  ),
                                  hintText: StringFile.digiteAqui,
                                ),
                              )),
                          Container(
                              margin: EdgeInsets.only(
                                  right: 5, left: 5, top: 15, bottom: 0),
                              child: StreamBuilder<Calling>(
                                  key: keyB8,
                                  stream: callingBloc.myCalling,
                                  builder: (context, snapshot) {
                                    IconData ccBrandIcon =
                                        Utils.getIconToPayment(snapshot);

                                    return snapshot.data == null
                                        ? loadElements(context)
                                        : titleDescriptionBigMobileWidget2(
                                            context, action: () async {
                                            profileBloc.verifyNeedCpf(context,
                                                (containsCpf) async {
                                              if (containsCpf != null) {
                                                showBottomSheetWallet(context,
                                                    (selected) {
                                                  callingBloc.setSelectedWallet(
                                                      selected);
                                                });
                                              }
                                            });

                                            // Modular.to.pushNamed(ConstantsRoutes.FORMPAYMENT);
                                          },
                                            padding: 0,
                                            title: 'Forma de pagamento',
                                            maxLine: 1,
                                            iconData: ccBrandIcon,
                                            description: snapshot
                                                    ?.data?.wallet?.number ??
                                                "Adicionar cartão");
                                  })),
                          Container(
                              margin: EdgeInsets.only(
                                  right: 5, left: 5, top: 15, bottom: 20),
                              child: StreamBuilder<Calling>(
                                  stream: callingBloc.myCalling,
                                  builder: (context, enableAddress) => !AttendanceUtils.isOnlyPresential(snapshotSelected.data) &&
                                          (enableAddress.data?.myAddress == null ||
                                              enableAddress.data.initLocal !=
                                                  null)
                                      ? SizedBox()
                                      : StreamBuilder<Calling>(
                                          stream: callingBloc.myCalling,
                                          builder: (context, snapshot) => snapshot
                                                      .data ==
                                                  null
                                              ? loadElements(context)
                                              : titleDescriptionBigMobileWidget2(
                                                  context,
                                                  padding: 0, action: () async {
                                                  showBottomSheetMyAddress(
                                                      context, (address) {
                                                    if (address != null) {
                                                      callingBloc
                                                          .selectedAddredss(
                                                              address);
                                                    }
                                                  });
                                                },
                                                  title: 'Endereço',
                                                  maxLine: 1,
                                                  iconData: MaterialCommunityIcons
                                                      .city_variant_outline,
                                                  description: snapshot?.data?.myAddress?.myAddress != null
                                                      ? getValueAddress(snapshot?.data)
                                                      : "Adicionar endereço")))),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  right: 10, left: 10, top: 5, bottom: 0),
                              child: Text(
                                snapshotSelected.data.isEmpty
                                    ? StringFile.valorHora
                                    : "Valor do serviço",
                                textAlign: TextAlign.center,
                                style: AppThemeUtils.normalSize(
                                    color: AppThemeUtils.colorPrimary,
                                    fontSize: 16),
                              )),
                          snapshotSelected.data.isEmpty
                              ? StreamBuilder<double>(
                                  stream: callingBloc.currentHourValue,
                                  builder: (context, snapshot) => snapshot
                                              .data ==
                                          null
                                      ? loadElements(context)
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                              top: 0,
                                              bottom: 20),
                                          child: Text(
                                            Utils.moneyFormat(snapshot.data),
                                            key: keyB9,
                                            textAlign: TextAlign.center,
                                            style: AppThemeUtils.normalBoldSize(
                                                color:
                                                    AppThemeUtils.colorPrimary,
                                                fontSize: 28),
                                          )))
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(
                                      right: 10, left: 10, top: 0, bottom: 20),
                                  child: Text(
                                    Utils.moneyFormat(snapshotSelected.data
                                        .fold(
                                            0,
                                            (previousValue, element) =>
                                                element.price + previousValue)),
                                    key: keyB9,
                                    textAlign: TextAlign.center,
                                    style: AppThemeUtils.normalBoldSize(
                                        color: AppThemeUtils.colorPrimary,
                                        fontSize: 28),
                                  )),
                          SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<Calling>(
                              stream: callingBloc.myCalling.stream,
                              initialData: Calling(),
                              builder: (context, snapshot) => Container(
                                  height: 45,
                                  margin: EdgeInsets.only(
                                      right: 20, left: 20, bottom: 30),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            height: 45,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary:
                                                        AppThemeUtils.lightGray,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)))),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                                child: Text(
                                                  StringFile.voltar,
                                                  style:
                                                      AppThemeUtils.normalSize(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                ))),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Container(
                                            height: 45,
                                            child: ElevatedButton(
                                              key: keyB10,
                                              style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context)
                                                      .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                  )),
                                              onPressed: () {
                                                // callingBloc.testeRefuzedPayment(context);
                                                profileBloc
                                                    .verifyNeedCpf(context,
                                                        (containsCpf) async {
                                                  if (containsCpf != null) {
                                                    var calling =
                                                        snapshot.data ??
                                                            Calling();

                                                    if ((calling.description ??
                                                            "")
                                                        .isEmpty) {
                                                      setState(() {
                                                        error =
                                                            "Nos conte como podemos ajudar?";
                                                      });
                                                    } else if ((calling
                                                                    .description ??
                                                                "")
                                                            .length <=
                                                        9) {
                                                      setState(() {
                                                        error =
                                                            "Diga o que precisa em no mínimo 10 caracteres!";
                                                      });
                                                    } else if (callLing
                                                            .wallet ==
                                                        null) {
                                                      showBottomSheetWallet(
                                                          context, (selected) {
                                                        callingBloc
                                                            .setSelectedWallet(
                                                                selected);
                                                      });
                                                    } else if (callLing
                                                            .initHours !=
                                                        null) {
                                                      Utils.showSnackBar(
                                                          "Adicione tipo de atendimento clicando em 'Agora' para ser atendido o mais breve possível ou 'Agendar' para agendar um horario",
                                                          context);
                                                    } else if (callLing
                                                                .initLocal !=
                                                            null &&
                                                        !AttendanceUtils
                                                            .isOnlyPresential(
                                                                snapshotSelected
                                                                    .data)) {
                                                      Utils.showSnackBar(
                                                          "Adicione como será atendido clicando em 'Presencial' para o Tecnoanjo ir ate sua casa ou 'Remoto' para ser atendido pela internet",
                                                          context);
                                                    } else if (AttendanceUtils
                                                            .isOnlyPresential(
                                                                snapshotSelected
                                                                    .data) &&
                                                        callLing.myAddress ==
                                                            null) {
                                                      Utils.showSnackBar(
                                                          "Adicione um endereço para continuar",
                                                          context);
                                                    } else {
                                                      callingBloc
                                                          .soliciteAttendance(
                                                              context,
                                                              onSucess: () {
                                                        SchedulerBinding
                                                            .instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          Modular.to.popUntil(
                                                              ModalRoute.withName(
                                                                  ConstantsRoutes
                                                                      .HOMEPAGE));
                                                        });
                                                      });
                                                    }
                                                  }
                                                });
                                              },
                                              //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView())),
                                              child: Text(
                                                "Solicitar",
                                                style: AppThemeUtils.normalSize(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                            )),
                                      )
                                    ],
                                  )))
                        ])))));
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyB1,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "",
                          style: AppThemeUtils.normalSize(
                              color: AppThemeUtils.black, fontSize: 26),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    "Aqui você pode escolher se quer ser atendido ",
                                style: AppThemeUtils.normalSize(
                                    fontSize: 20,
                                    color: AppThemeUtils.whiteColor)),
                            TextSpan(
                                text: "agora ",
                                style: AppThemeUtils.normalBoldSize(
                                    fontSize: 20, color: AppThemeUtils.black)),
                            TextSpan(
                                text: "ou se quer ",
                                style: AppThemeUtils.normalSize(
                                    fontSize: 20,
                                    color: AppThemeUtils.whiteColor)),
                            TextSpan(
                                text: "agendar um horário",
                                style: AppThemeUtils.normalBoldSize(
                                    fontSize: 20, color: AppThemeUtils.black))
                          ],
                        )),

                    // Text(
                    //   "Aqui você",
                    //   style: AppThemeUtils.normalSize(color: Colors.white,fontSize: 18),
                    // ),
                  ),
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyB2,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Agora",
                    style: AppThemeUtils.normalBoldSize(
                        color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                    child: Text(
                      "Se você precisa do atendimento agora!",
                      style: AppThemeUtils.normalSize(
                          color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyB3,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Agendar",
                    style: AppThemeUtils.normalBoldSize(
                        color: Colors.white, fontSize: 20.0),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                    child: Text(
                      "Se você precisa agendar um horário para o atendimento!",
                      style: AppThemeUtils.normalSize(
                          color: Colors.white, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    if (!AttendanceUtils.isOnlyPresential(
        callingBloc.listServicesSelectedSubject.stream.value)) {
      targets.add(
        TargetFocus(
          identify: "Target 4",
          keyTarget: keyB4,
          color: AppThemeUtils.colorPrimaryDark2,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Forma de atendimento",
                      style: AppThemeUtils.normalBoldSize(
                          color: Colors.white, fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, right: 15, left: 15, bottom: 10),
                      child: Text(
                        "Aqui você escolhe qual tipo de atendimento você prefere",
                        style: AppThemeUtils.normalSize(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                    // Container(
                    //   color: Colors.white,
                    //   padding: EdgeInsets.all(10),
                    //   width: double.infinity,
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         "Presencial",
                    //         style: AppThemeUtils.normalBoldSize(
                    //             color: Colors.black, fontSize: 20.0),
                    //       ),
                    //       Padding(
                    //           padding: const EdgeInsets.only(
                    //               top: 10.0, right: 15, left: 15, bottom: 10),
                    //           child: Text(
                    //             "Seu Tecnoanjo vai até a sua localização para te ajudar",
                    //             style: AppThemeUtils.normalSize(
                    //                 color: Colors.grey, fontSize: 16),
                    //           )),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10,),
                    // Container(
                    //     color: Colors.white,
                    //     padding: EdgeInsets.all(10),
                    //     width: double.infinity,
                    //     child: Column(children: [
                    //       Text(
                    //         "Remoto",
                    //         style: AppThemeUtils.normalBoldSize(
                    //             color: Colors.black, fontSize: 20.0),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(
                    //             top: 10.0, right: 15, left: 15),
                    //         child: Text(
                    //           "Seu Tecnoanjo vai te ajudar pela internet",
                    //           style: AppThemeUtils.normalSize(
                    //               color: Colors.grey, fontSize: 16),
                    //         ),
                    //       )
                    //     ])),
                  ],
                ),
              ),
            )
          ],
          shape: ShapeLightFocus.RRect,
          radius: 5,
        ),
      );
      targets.add(
        TargetFocus(
          identify: "Target 1",
          keyTarget: keyB5,
          color: AppThemeUtils.colorPrimaryDark2,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Presencial",
                      style: AppThemeUtils.normalBoldSize(
                          color: Colors.white, fontSize: 20.0),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                      child: Text(
                        "Seu Tecnoanjo vai até a sua localização para te ajudar",
                        style: AppThemeUtils.normalSize(
                            color: Colors.white, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
          shape: ShapeLightFocus.RRect,
          radius: 5,
        ),
      );
      targets.add(
        TargetFocus(
          identify: "Target 1",
          keyTarget: keyB6,
          color: AppThemeUtils.colorPrimaryDark2,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Remoto",
                      style: AppThemeUtils.normalBoldSize(
                          color: Colors.white, fontSize: 20.0),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                      child: Text(
                        "Seu Tecnoanjo vai te ajudar pela internet",
                        style: AppThemeUtils.normalSize(
                            color: Colors.white, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
          shape: ShapeLightFocus.RRect,
          radius: 5,
        ),
      );
    }

    targets.add(
      TargetFocus(
        identify: "Target 7",
        keyTarget: keyB7,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                    child: Text(
                      "Descreva aqui qual o seu problema e como podemos  te ajudar.",
                      style: AppThemeUtils.normalSize(
                          color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Target 8",
        keyTarget: keyB8,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                    child: Text(
                      "Aqui você vai inserir um cartão de crédito para pagar pelos serviços do seu Tecnoanjo",
                      style: AppThemeUtils.normalSize(
                          color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 9",
        keyTarget: keyB9,
        color: AppThemeUtils.colorPrimaryDark2,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                    child: Text(
                      "Este é valor total dos serviços selecionados. \nO valor do serviço só será contabilizado quando seu atendimento for iniciado.",
                      style: AppThemeUtils.normalSize(
                          color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        shape: ShapeLightFocus.RRect,
        radius: 5,
      ),
    );
    // targets.add(
    //   TargetFocus(
    //     identify: "Target 10",
    //     keyTarget: keyB10,
    //     color: AppThemeUtils.colorPrimaryDark2,
    //     contents: [
    //       TargetContent(
    //         align: ContentAlign.bottom,
    //         child: Container(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: <Widget>[
    //               Text(
    //                 "Tudo pronto?",
    //                 style: AppThemeUtils.normalBoldSize(
    //                     color: Colors.white,
    //                     fontSize: 20.0),
    //               ),
    //               Padding(
    //                     padding: const EdgeInsets.only(top: 10.0,right:15  ,left:15),
    //                 child: Text(
    //                   "Apôs tudo concluído basta solicitar seu atendimento!",
    //                   style: AppThemeUtils.normalSize(color: Colors.white,fontSize: 18),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       )
    //     ],
    //     shape: ShapeLightFocus.RRect,
    //     radius: 5,
    //   ),
    // );
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Colors.red,
      textSkip: "Pular",
      hideSkip: true,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        appBloc.setSecondOnboard(false);
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onSkip: () {
        appBloc.setSecondOnboard(false);
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }
}

getValueAddress(Calling data) {
  if (data?.myAddress?.id == null) {
    return "--";
  } else {
    return "${Utils.addressFormatMyData(data.myAddress)}";
  }
}
