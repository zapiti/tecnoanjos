import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_generic_textfield.dart';
import 'package:tecnoanjostec/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjostec/app/models/page/response_paginated.dart';
import 'package:tecnoanjostec/app/models/pairs.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/core/profile_repository.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/page/cpf_page.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/widget/profile_builder.dart';
import 'package:tecnoanjostec/app/modules/general/home/modules/profile/widget/registre/registre_bloc.dart';

import 'package:tecnoanjostec/app/routes/constants_routes.dart';
import 'package:tecnoanjostec/app/utils/string/string_file.dart';
import 'package:tecnoanjostec/app/utils/utils.dart';
import 'models/profile.dart';

class ProfileBloc extends Disposable {
  //dispose will be called automatically by closing its streams
  var userProfile = BehaviorSubject<ResponsePaginated>();
  var userInfos = BehaviorSubject<Profile>();
  var isOnline = BehaviorSubject<bool>.seeded(false);
  var controllGetInfo = BehaviorSubject<bool>.seeded(false);
  var _repository = Modular.get<ProfileRepository>();
  static var constantValues = Pairs([
    Pairs("M", StringFile.masculino),
    Pairs("F", StringFile.feminino),
  ], []);
  var genderList = BehaviorSubject<Pairs>.seeded(constantValues);

  var userImage = BehaviorSubject<String>();

  sendMessage(String message, Attendance attendance) {
    _repository.sendNotificationMessage(message, attendance);
  }

  Future<Profile> getDataOnly() async {
    var result = await _repository.getUserData();

    userProfile.sink.add(result);
    return result.content;
  }

  getUserData(
    BuildContext context, {
    bool ignoreCash = false,
  }) async {
    var userData = userProfile?.stream?.value;
    if (userData == null) {
      var result = await _repository.getUserData();
      if (userProfile?.stream?.value == null) {
        userData = result;
        userProfile.sink.add(result);
      }
    }

    if (userData?.content?.isFirstLogin ?? false) {
      if (!(userData?.content?.inOnboard ?? false)) {
        userData?.content?.inOnboard = true;
        userProfile?.sink?.add(userData);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Modular.to.pushReplacementNamed(ConstantsRoutes.ONBOARD);
        });
      }
    }
  }

  Future<void> createConfig(
      BuildContext context, List qualifications, Function success) async {
    var registreBloc = Modular.get<RegistreBloc>();

    registreBloc.controllerPassActualPass.clear();
    registreBloc.controllerConfirmPass.clear();
    registreBloc.controllerPassActualPass.clear();
    showBottomSheetAlterPass(context, registreBloc, hasNegative: true, onSuccess: () async {
      showLoading(true);

      var result = await _repository.createConfig(qualifications);
      showLoading(false);
      if (result.error == null) {
        success();
      } else {
        showGenericDialog(
            context: context,
            title: StringFile.Erro,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {
              Navigator.of(context).pop();
            },
            positiveText: StringFile.OK);
      }
    });
  }

  void saveUserImage(BuildContext context, String img64,
      {Function(bool) success}) async {
    showLoading(true);

    var result = await _repository.saveUserImage(img64);
    showLoading(false);
    if (result.error == null) {
      getUserImage(ignoreCash: true);
      success(true);
    } else {
      success(false);
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  getUserImage({ignoreCash = false}) async {
    if (ignoreCash) {
      userImage.sink.add(null);
    }
    if (userImage.stream.value == null) {
      var image = await _repository.getUserImage();
      if (image.content is String) {
        userImage.sink.add(image.content);
      }
    }
  }

  getStatus(BuildContext context) async {
    var result = await _repository.getStatus();
    if (result.error == null) {
      isOnline.sink.add(result.content);
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  updateIsOnlineInThisApp(bool update) async {}

  updateStatus(GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      bool isOnlineUser) async {
    showLoading(true);

    var result = await _repository.updateStatus(isOnlineUser);
    showLoading(false);
    if (result.error == null) {
      isOnline.sink.add(isOnlineUser);
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  void editField(BuildContext context, String title,
      {String address,
      String cpf,
      String birthDate,
      String gender,
      String email,
      String cellPhone}) {
    var textEditing = TextEditingController();
    textEditing.text =
        address ?? cpf ?? birthDate ?? gender ?? email ?? cellPhone;
    var name = address != null
        ? "address"
        : cpf != null
            ? "cpf"
            : birthDate != null
                ? "birthDate"
                : gender != null
                    ? "gender"
                    : email != null
                        ? "email"
                        : "cellPhone";

    var keyboardType =
        address != null || birthDate != null || gender != null || email != null
            ? TextInputType.text
            : TextInputType.number;

    showTextFieldGenericDialog(
        context: context,
        title: title,
        controller: textEditing,
        keyboardType: keyboardType,
        positiveCallback: () async {
          await editFieldProfile(name, textEditing.text, context, () {});
        },
        negativeCallback: () {});
  }

  Future editFieldProfile(String name, String value, BuildContext context,
      Function onSuccess) async {
    var dataElement = {name: value.toString()};
    showLoading(true);

    var result = await _repository.updateUserDataOnly(dataElement);
    showLoading(false);
    if (result.error == null) {
      userProfile.sink.add(null);

      getUserData(context, ignoreCash: true);
      onSuccess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  Future<Profile> getUserInfo({bool isReload = false}) async {
    var result = await _repository.getUserInfo();
    if (result.error == null) {
      Profile profile = Profile();
      profile.hoursWorked =
          result.content['hoursWorked']?.toString() ?? "00:00";

      profile.avaliations =
          result.content['avaliationAverage']?.toString() ?? "0.0";
      profile.level = Level.fromMap(result.content['level']);
      profile.name = result.content['userName'].toString();
      profile.cpf = result.content['cpfCnpj'];
      profile.isFirstLogin = result.content['isFirstLogin'];
      profile.schedule =
          (result.content['userAttendance'] ?? 0).toStringAsFixed(0);
      userInfos.sink.add(profile);
      return profile;
    } else {
      var profile = await _repository.getUserData();
      userInfos.sink.add(profile.content);
      return profile.content;
    }
  }

  @override
  void dispose() {
    userImage.drain();
    userProfile.drain();
    controllGetInfo.drain();
    isOnline.drain();
    genderList.drain();
    userInfos.drain();
  }

  Future callAddCpf(BuildContext context, Function onSuccess) async {
    var group =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CpfPage();
    }));
    if (group == true) {
      onSuccess();
    }
  }

  Future<void> updateCpf(BuildContext context, MaskedTextController controller,
      Function onSuccess) async {
    if (!CPF.isValid(controller.text)) {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: StringFile.cpfInvalido,
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    } else {
      showLoading(true);

      var result = await _repository.updateUserDataOnly({
        "cpf": Utils.removeMask(controller.text),
      });
      showLoading(false);
      if (result.error == null) {
        userProfile.sink.add(null);
        userInfos.sink.add(null);
        getUserData(context, ignoreCash: true);

        onSuccess();
      } else {
        showGenericDialog(
            context: context,
            title: StringFile.Erro,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    }
  }

  Future<void> requestTokenSms(BuildContext context, username,
      {Function onSuccess}) async {
    var result = await _repository.requestTokenSms(username);
    if (result.error == null) {
      onSuccess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.Erro,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }

  sendVerifiCodExists(String pin, username) async {
    var result = await _repository.sendVerifiCodExists(pin, username);
    return result;
  }
}
