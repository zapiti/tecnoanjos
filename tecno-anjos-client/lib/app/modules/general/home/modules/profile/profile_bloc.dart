import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tecnoanjosclient/app/app_bloc.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic_textfield.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/models/current_user.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/models/pairs.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/attendance/models/attendance.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/profile/page/cpf_page.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';
import 'core/profile_repository.dart';
import 'models/profile.dart';

class ProfileBloc extends Disposable {
  //dispose will be called automatically by closing its streams
  var userProfile = BehaviorSubject<ResponsePaginated>();
  var userInfos = BehaviorSubject<Profile>();
  var isOnline = BehaviorSubject<bool>.seeded(false);
  static var constantValues = Pairs([
    Pairs("M", "Masculino"),
    Pairs("F", "Feminino"),
    //  Pairs("ND", "Não declarar")
  ], []);
  var genderList = BehaviorSubject<Pairs>.seeded(constantValues);

  var _repository = Modular.get<ProfileRepository>();

  var userImage = BehaviorSubject<String>();

  var loadCircleButton = BehaviorSubject<int>.seeded(0);

  var avaliation = BehaviorSubject<bool>.seeded(false);

  getUserData({bool ignoreCash = false}) async {
    var userData = userProfile?.stream?.value?.content;
    if (ignoreCash) {
      var result = await _repository.getUserData();
//      if (result?.content?.isFistLogin ?? false) {
//        AttendanceUtils.pushNamed(context,ConstantsRoutes.ONBOARD);
//      } else {
//        receiverCalledBloc.getListReceivers(appBloc);
//      }
      userProfile?.sink?.add(result);
    } else {
      if (userData == null) {
        var result = await _repository.getUserData();

//        if (result?.content?.isFirstLogin ?? false) {
//          AttendanceUtils.pushNamed(context,ConstantsRoutes.ONBOARD);
//        } else {
//          receiverCalledBloc.getListReceivers(appBloc);
//        }
        userProfile.sink.add(result);
      }
    }
  }

  void saveUserImage(BuildContext context, String img64,
      {Function(bool) sucess}) async {
    showLoading(true);

    var result = await _repository.saveUserImage(img64);
    showLoading(false);
    if (result.error == null) {
      getUserImage(ignoreCash: true);
      sucess(true);
    } else {
      sucess(false);
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  sendMessage(String message, Attendance attendance) {
    _repository.sendNotificationMessage(message, attendance);
  }

  getUserImage({ignoreCash = false}) async {
    if (ignoreCash) {
      userImage.sink.add(null);
    }
    if (userImage.stream.value == null) {
      var image = await _repository.getUserImage();
      if (image.content != null) {
        if (image.content is String) {
          if (!image.content.toString().contains('undefined')) {
            userImage.sink.add(image.content);
          }
        }
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
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.ok);
    }
  }

  updateStatus(GlobalKey<ScaffoldState> _scaffoldKey, BuildContext context,
      bool isOnlineUser) async {
    // showLoadingDialog(context, title: "Atualizando status");

    var result = await _repository.updateStatus(isOnlineUser);
    // Navigator.of(context).pop();
    if (result.error == null) {
      isOnline.sink.add(isOnlineUser);
//      Utils.showSnackBar(
//          "Você está ${isOnlineUser ? "Online" : "Offline"}", _scaffoldKey);
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

  void editField(BuildContext context, String title,
      {String address,
        String cpf,
        String birthDate,
        String gender,
        String email,
        String cellPhone,
        String nameUser,
        List<TextInputFormatter> inputFormatters}) {
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
        : nameUser != null
        ? "name"
        : "cellPhone";

    var keyboardType = address != null ||
        birthDate != null ||
        gender != null ||
        email != null ||
        nameUser != null
        ? TextInputType.text
        : TextInputType.number;


    showTextFieldGenericDialog(
        context: context,
        title: title,
        controller: textEditing,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        positiveCallback: ()  {
          var dataElement = {name: textEditing.text.toString()};
          //  showLoadingDialog(context, title: "Atualizando dados cadastrais");

          if (nameUser != null && dataElement.length < 3) {
            showGenericDialog(
                context: context,
                title: StringFile.opps,
                description:
                StringFile.nameMenos3Letras,
                iconData: Icons.error_outline,
                positiveCallback: () {},
                positiveText: StringFile.ok);
          } else {
         _repository.updateUserDataOnly(dataElement).then((result){
           if (result.error == null) {
             showGenericDialog(
                 context: context,
                 title: StringFile.sucesso,
                 description: StringFile.dadosAtualizadosComSucesso,
                 iconData: Icons.check,
                 positiveCallback: () {
                   userProfile?.sink?.add(null);
                   getUserData(ignoreCash: true);
                   Navigator.of(context).pop();
                 },
                 positiveText: StringFile.ok);
           } else {
             showGenericDialog(
                 context: context,
                 title: StringFile.opps,
                 description:
                 "${result.error}",
                 iconData: Icons.error_outline,
                 positiveCallback: () {},
                 positiveText: StringFile.ok);
           }
            });
            //    Navigator.of(context).pop();

          }
        },
        negativeCallback: () {});
  }

  verifyNeedCpf(BuildContext context, Function(String) onSucess) async {
    var profile = userInfos.stream.value;
    if (profile == null) {
      showLoading(true);

      profile = await getUserInfo();
      showLoading(false);
    }
    if (profile?.cpf == null) {
      await callAddCpf(context, (resulted) {
        onSucess(resulted);
      });
    } else {
      onSucess(profile?.cpf);
    }
  }

  Future callAddCpf(BuildContext context, Function(String) onSucess,
      {String defaultNumber = ""}) async {
    var group =
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CpfPage(defaultNumber);
    }));
    if (group != null) {
      onSucess(group);
    } else {
      onSucess(null);
    }
  }

  Future editFieldProfile(String name, String value, BuildContext context,
      Function onSucess) async {
    var dataElement = {name: value.toString()};
    //  showLoadingDialog(context, title: "Atualizando dados cadastrais");

    var result = await _repository.updateUserDataOnly(dataElement);
    //   Navigator.of(context).pop();
    if (result.error == null) {
      // showGenericDialog(context:context,
      //     title: "Sucesso",
      //     description: "Dados atualizados com sucesso",
      //     iconData: Icons.check,
      //     positiveCallback: () {
      getUserInfo(isReload: true);
      userProfile.sink.add(null);

      getUserData(ignoreCash: true);

      onSucess();
      // },
      // positiveText: StringFile.ok);
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

  getUserInfo({bool isReload = false}) async {

    if (userInfos.stream.value == null) {
      var result = await _repository.getUserInfos();

      if (result.error == null) {
        Profile profile = Profile.fromMap(result.content);
        profile.hoursWorked = result.content['hoursWorked']?.toString();
        profile.avaliations =
            (result.content['avaliationAverage'] ?? 0)?.toString();
        //  profile.level = result.content['level']?.toString();
        profile.name = result.content['userName']?.toString();
        profile.cpf = result.content['cpfCnpj']?.toString();
        profile.schedule = (result.content['userAttendance'] ?? 0)?.toString();
        final appBloc = Modular.get<AppBloc>();
        userInfos.sink.add(profile);
        final currentUser = CurrentUser.fromMap(profile.toMap());
        appBloc.setCurrent(currentUser);
        return profile;
      } else {
        var profile = await _repository.getUserData();
        userInfos.sink.add(profile.content);

        return profile.content;
      }
    }
  }

  Future<void> updateCpf(BuildContext context, MaskedTextController controller,
      Function onSucess) async {

    if (!CPF.isValid(controller.text)) {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
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
        getUserData();

        onSucess();
      } else {
        showGenericDialog(
            context: context,
            title: StringFile.opps,
            description: "${result.error}",
            iconData: Icons.error_outline,
            positiveCallback: () {},
            positiveText: StringFile.OK);
      }
    }
  }

  @override
  void dispose() {
    userImage.drain();
    userProfile.drain();
    isOnline.drain();
    userInfos.drain();
    genderList.drain();
    avaliation.drain();
    loadCircleButton.drain();
  }

  Future<void> updateFields(BuildContext context, Map<String, String> map,
      Function onSuccess) async {
    showLoading(true);

    var result = await _repository.updateUserDataOnly(map);
    showLoading(false);
    if (result.error == null) {
      userProfile.sink.add(null);
      userInfos.sink.add(null);
      getUserData();
      onSuccess();
    } else {
      showGenericDialog(
          context: context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }
}
