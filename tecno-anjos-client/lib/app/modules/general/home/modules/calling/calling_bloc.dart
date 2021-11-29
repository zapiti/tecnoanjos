import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/attendance_bloc.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/refused_payment_bottom_sheet.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/core/my_address_repository.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/models/profile.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/profile_bloc.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/core/wallet_repository.dart';

import 'package:tecnoanjosclient/app/modules/general/home/modules/wallet/models/wallet.dart';
import 'package:tecnoanjosclient/app/modules/firebase/current_attendance/start_called/start_called_bloc.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/date_utils.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'core/calling_repository.dart';
import 'model/calling.dart';
import 'model/service_prod.dart';

class CallingBloc extends Disposable {
  var myCalling = BehaviorSubject<Calling>.seeded(Calling());
  var containsLocation = BehaviorSubject<bool>.seeded(false);
  var hideConfirmButton = BehaviorSubject<bool>.seeded(false);
  var _repository = Modular.get<CallingRepository>();
  var dateController = TextEditingController();
  var controllerObs = TextEditingController();

  var currentHourValue = BehaviorSubject<double>();

  var selectedRemotePresencial = BehaviorSubject<bool>.seeded(false);

  var listServicesSubject = BehaviorSubject<List<Pairs>>();

  var listServicesSelectedSubject = BehaviorSubject<List<ServiceProd>>.seeded([]);

  void updateAttendanceByAttendance(Attendance attendance) {
    var calling = Calling.fromMap(attendance);
    myCalling.sink.add(calling);
    dateController.text = MyDateUtils.parseDateTimeFormat(
        calling.hourAttendance, null,
        format: "dd/MM/yyyy HH:mm");
  }

  void selectedText(String descrition) {
    var calling = myCalling.stream.value;
    calling.description = descrition;
    myCalling.sink.add(calling);
  }

  void selectedDate(DateTime hour) {
    var calling = myCalling.stream.value ?? Calling();
    calling.hourAttendance = hour;
    calling.initHours = null;
    myCalling.sink.add(calling);
  }

  @override
  void dispose() {
    myCalling.drain();
    selectedRemotePresencial.drain();
    containsLocation.drain();
    hideConfirmButton.drain();
    currentHourValue.drain();
    listServicesSubject.drain();
    listServicesSelectedSubject.drain();
  }

  getListService() async {
    final response = await _repository.getListService();

    final totalList =
        ObjectUtils.parseToObjectList<ServiceProd>(response.content) ?? [];

    final listPresetial = totalList
        .where((element) => element.type == ServiceProd.PRESENTIAL)
        .toList();
    final pairs1 = Pairs("Serviços presenciais", listPresetial,third:  ServiceProd.PRESENTIAL);
    final listRemote = totalList
        .where((element) => element.type != ServiceProd.PRESENTIAL)
        .toList();
    final pairs2 = Pairs("Serviços remotos", listRemote,third:  ServiceProd.REMOTE);
    // final listHybrid = totalList
    //     .where((element) => element.type == ServiceProd.HYBRID)
    //     .toList();
    // final pairs3 = Pairs("Serviços híbridos", listHybrid,third:  ServiceProd.HYBRID);

    listServicesSelectedSubject.sink.add([]);
    listServicesSubject.sink.add([pairs1, pairs2]);
  }

  getValueCreated() async {
    final myAddressRepository = MyAddressRepository();

    myAddressRepository.getOneAddress().then((myAddress) {
      var calling = myCalling.stream.value ?? Calling();
      calling.myAddress = myAddress;
      myCalling.sink.add(calling);
    });

    final walletRepository = WalletRepository();
    selectedRemotePresencial.sink.add(false);
    walletRepository.getOneWallet().then((wallet) {
      var calling = myCalling.stream.value ?? Calling();
      calling.wallet = wallet;
      myCalling.sink.add(calling);
    });
  }

  void selectedImage(String image) {
    var calling = myCalling.stream.value;
    calling.image = image;
    myCalling.sink.add(calling);
  }

  selectedAddredss(MyAddress address) {
    var calling = myCalling.stream.value;
    calling.myAddress = address;
    calling.initLocal = null;
    myCalling.sink.add(calling);
  }

  setSelectedWallet(Wallet wallet) {
    var calling = myCalling.stream.value;
    calling.wallet = wallet;
    myCalling.sink.add(calling);
  }

  Future<void> soliciteAttendance(BuildContext context,
      {Function onSucess}) async {
    var calling = myCalling.stream.value;
    var _dateTime = await MyDateUtils.getTrueTime();
    if (calling.hourAttendance != null &&
        MyDateUtils.compareTwoDates(calling.hourAttendance,
            MyDateUtils.convertDateToDate(_dateTime, _dateTime))) {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: StringFile.horarioMaiorQAtual,
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    } else {
      var profileBloc = Modular.get<ProfileBloc>();
      profileBloc.verifyNeedCpf(context, (containsCpf) async {
        if (containsCpf != null) {
          var currentBloc = Modular.get<StartCalledBloc>();
          showLoading(true);
          var tecnoFavorite = await _repository.checkFavoriteIsOn();
          var attendanceBloc = Modular.get<AttendanceBloc>();
          var currentHours = await MyDateUtils.getTrueTime();
          attendanceBloc.getTimeMaxHoursCancell(
              Attendance(createdAt: currentHours ?? DateTime.now()));
          showLoading(false);
          if (tecnoFavorite.error == null) {
            if (tecnoFavorite.content['isOnline'] == true) {
              callAttendance(context, currentBloc, onSucess);
              showLoading(false);
            } else {
              showLoading(false);
              showGenericDialog(
                  context: context,
                  title: StringFile.opps,
                  description: StringFile.tecnoFavoritoOffline,
                  iconData: Icons.error_outline,
                  positiveCallback: () {
                    var calling = myCalling.stream.value;
                    calling.ignoreFavorite = true;
                    myCalling.sink.add(calling);
                    callAttendance(context, currentBloc, onSucess);
                  },
                  negativeText: StringFile.cancelar,
                  negativeCallback: () {},
                  positiveText: StringFile.enviarParaTodos);
            }
          } else {
            callAttendance(context, currentBloc, onSucess);
          }
        } else {
          showGenericDialog(
              context: context,
              title: StringFile.opps,
              description: StringFile.cpfobrigatorio,
              iconData: Icons.error_outline,
              positiveCallback: () {},
              positiveText: StringFile.ok);
        }
      });
    }

//    var StartCalledBloc = Modular.get<StartCalledBloc>();
//    StartCalledBloc.setCurrentAttendance();
//    AttendanceUtils.goToHome();
  }

  testeRefuzedPayment(BuildContext context) {
    var attendance = Attendance(
        id: 14,
        userTecno: Profile(
          name: "Nathan Ranghel",
        ),
        totalValue: 90.0,
        createdAt: DateTime.now());
    callRePlayPayment(context, attendance, 10, () {});
  }

  callRePlayPayment(BuildContext context, Attendance attendance,
      double pendingAmount, Function onSuccess) {
    showBottomSheetRefuzedPayment(
        context: context,
        attendance: attendance,
        pendingAmount: pendingAmount,
        onConfirm: (wallet) {
          if (wallet == null) {
            showGenericDialog(
                context: context,
                title: StringFile.opps,
                description: "Adicione uma forma de pagamento",
                iconData: Icons.error_outline,
                positiveCallback: () {},
                positiveText: StringFile.ok);
          } else {
            payPendingAttendance(context, attendance, wallet, onSuccess);
          }
        });
  }

  payPendingAttendance(BuildContext context, Attendance attendance,
      Wallet wallet, Function onSuccess) async {
    showLoading(true);
    var result = await _repository.payPendingAttendance(attendance, wallet);

    if (result.error == null) {
      onSuccess();
    } else {
      showLoading(false);
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  Future callAttendance(BuildContext context, StartCalledBloc currentBloc,
      Function onSucess) async {
    try {
      showLoading(true);

      final calling = myCalling.stream.value;
      calling.serviceItems = listServicesSelectedSubject.stream.value;
      // calling.myAddress =
      // selectedRemotePresencial.stream.value == false ? null : calling.myAddress;
      var result = await _repository.soliciteAttendance(calling);

      // currentHourValue

      showLoading(false);
      if (result.error == null) {

        onSucess();
        clearAttendance();

        if (myCalling.stream.value.hourAttendance == null) {
          AmplitudeUtil.createEvent(
              AmplitudeUtil.atendimentoImediatoCriadoComSucesso);
        } else {
          AmplitudeUtil.createEvent(
              AmplitudeUtil.atendimentoAgendadoCriadoComSucesso);
        }

        // showGenericDialog(context:context,
        //     title: "Solicitação feita com sucesso!",
        //     description:
        //         "Lembramos que só vamos cobrar você ao iniciar o atendimento. ;)",
        //     iconData: Icons.check_circle_outline, positiveCallback: () {
        //   // currentBloc.awaitAttendance.sink.add(
        //   //     Attendance.fromMap(myCalling.stream.value?.toMapAttendance()));
        //   // currentBloc.awaitAttendanceTemp.sink.add(ResponsePaginated(content: Attendance.fromMap(myCalling.stream.value?.toMapAttendance())));
        //   // currentBloc.getAttendanceNotAccept();
        //
        //     //  UpdateFirebaseUtils.setCollectionAccept(result.content);
        //   onSucess();
        // }, positiveText: StringFile.ok);
      } else {
        if (result.others.toString().contains("pendingAmount")) {
          final attendance =
              Attendance.fromMap(result.others["pendingAttendance"]);
          final pendingAmount =
              double.tryParse((result.others["pendingAmount"] ?? 0).toString());
          callRePlayPayment(context, attendance, pendingAmount, () {
            callAttendance(context, currentBloc, onSucess);
          });
        } else {
          if (myCalling.stream.value.hourAttendance == null) {
            AmplitudeUtil.createEvent(AmplitudeUtil.atendimentoImediatoFalha);
          } else {
            AmplitudeUtil.createEvent(AmplitudeUtil.atendimentoAgendadoFalha);
          }

          showGenericDialog(
              context: context,
              title: StringFile.opps,
              description: "${result.error}",
              iconData: Icons.error_outline,
              positiveCallback: () {},
              positiveText: StringFile.ok);
        }
      }
    } catch (e) {}
  }

  void clearAttendance() {
    controllerObs.clear();
    dateController.clear();
    myCalling.sink.add(Calling());
  }

  Future<void> getCurrentMoney() async {
    var currentMoney = await _repository.currentMoney();
    if (currentMoney.error == null) {
      currentHourValue.sink.add(currentMoney.content);
    }
  }

  Future<void> soliciteAttendanceResend(
      Attendance attendance, DateTime date, BuildContext context,
      {Function() onSuccess}) async {
    showLoading(true);
    var result = await _repository.soliciteAttendanceResend(attendance, date);
    showLoading(false);
    if (result.error == null) {
      onSuccess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }
}
