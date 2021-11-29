

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:rxdart/rxdart.dart';
import 'package:search_cep/search_cep.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/utils/amplitude/amplitude_util.dart';
import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';


import 'core/my_address_repository.dart';
import 'model/my_address.dart';

class MyAddressBloc extends Disposable {
  final TextEditingController cepController =
      MaskedTextController(mask: '00000-000');

  final TextEditingController controllerTitle =
      TextEditingController(text: "Casa");
  final TextEditingController streetController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController complementController = TextEditingController();
  final TextEditingController neighboorhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  var tempAdress = BehaviorSubject<MyAddress>.seeded(MyAddress());
  var selectedAddress = BehaviorSubject<MyAddress>();
  var listAddressForm = BehaviorSubject<List<MyAddress>>();
  var editAddress = BehaviorSubject<bool>.seeded(false);
  var _repository = Modular.get<MyAddressRepository>();

  searchCep(String cep, BuildContext context) async {
    if (cep.length == 9) {
      MyAddress newState = tempAdress.stream.value ?? MyAddress();
    //  var progress = ProgressHUD.of(context);
    //  progress.showWithText('Buscando cep');
      final call = await ViaCepSearchCep()
          .searchInfoByCep(cep: cep.replaceAll(".", "").replaceAll("-", ""));

      var result = call.getOrElse(() => null);
    //  progress.dismiss();
      if (result != null) {
        if (result?.logradouro != null && result.logradouro.isNotEmpty) {
          newState.myAddress = result.logradouro;
          streetController.text = result.logradouro;
        }

        if (result?.bairro != null && result.bairro.isNotEmpty) {
          newState.neighborhood = result.bairro;
          neighboorhoodController.text = result.bairro;
        }

        if (result?.localidade != null && result.localidade.isNotEmpty) {
          newState.nameRegion = result?.localidade;
          cityController.text = result?.localidade;
        }

        if (result?.uf != null && result.uf.isNotEmpty) {
          newState.uf = result?.uf;
          stateController.text = result?.uf;
        }
        tempAdress.sink.add(newState);
      } else {
        AmplitudeUtil.createEvent(AmplitudeUtil.cepNaoEncontrado);
        Flushbar(
          flushbarStyle: FlushbarStyle.GROUNDED,
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: AppThemeUtils.colorPrimary,
          message: "Não encontramos seus endereço! \nVerifique seu cep.",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: AppThemeUtils.whiteColor,
          ),
          duration: Duration(seconds: 5),
        )..show(context);
      }
    }
  }

  saveAddress(BuildContext context, bool isSimpleNotDismissable,
      Function(MyAddress p1) selectedItem) async {

    MyAddress tempAddress = tempAdress.stream.value ?? MyAddress();
    tempAddress.nameRegion = cityController.text;
    tempAddress.postal = cepController.text;
    tempAddress.myAddress = streetController.text;
    tempAddress.num = numberController.text;
    tempAddress.complement = complementController.text;
    tempAddress.neighborhood = neighboorhoodController.text;
    tempAddress.uf = stateController.text;
    tempAddress.title = controllerTitle.text;
    tempAddress.isMain = true;

    var error;
    if (tempAddress.postal == null || tempAddress.postal.toString().isEmpty) {
      error = StringFile.cepNaoPodeSerVazio;
    } else if (tempAddress.postal == "00000000" ||
        tempAddress.postal.length < 8) {
      error = StringFile.cepInvalidado;
    } else if (tempAddress.myAddress == null ||
        tempAddress.myAddress.toString().isEmpty) {
      error = StringFile.enderecoNaoPodeSerVazio;
    } else if (tempAddress.title == null ||
        tempAddress.title.toString().isEmpty) {
      error = StringFile.descricaoNaoPodeSerVazio;
    } else if (tempAddress.num == null || tempAddress.num.toString().isEmpty) {
      error = StringFile.numeroNaoPodeSerVazio;
    } else if (tempAddress.neighborhood == null ||
        tempAddress.neighborhood.toString().isEmpty) {
      error = StringFile.bairroNaoPodeSerVazio;
    } else if ((tempAddress.uf?.toString() ?? "").isEmpty) {
      error = StringFile.cepParaIndicarEstado;
    } else if (tempAddress.nameRegion == null ||
        tempAddress.nameRegion.toString().isEmpty) {
      error = StringFile.cepParaIndicarEstado;
    }

    if (error != null) {
      AmplitudeUtil.createEvent(AmplitudeUtil.falhaAoSalvarEndereco);
      showGenericDialog(
          context: context,
          title: StringFile.atencao,
          description: "$error",
          iconData: Icons.error_outline,
          positiveCallback: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          positiveText: StringFile.ok);
    } else {
      AmplitudeUtil.createEvent(AmplitudeUtil.sucessoAoSalvarEndereco);
      showLoading(true);
      var response = await _repository.saveAddress(tempAddress);
      showLoading(false);
      if (response?.error != null) {
        showGenericDialog(
            context: context,
            title: "Erro",
            description: response.error ?? "Sem resposta",
            iconData: Icons.error,
            positiveCallback: () {},
            positiveText: "OK");
      } else {
        // showGenericDialog(
        //     context: context,
        //     title: "Sucesso",
        //     description: tempAddress?.id == null
        //         ? "Endereço salvo com sucesso"
        //         : "Endereço editado com sucesso",
        //     iconData: Icons.check_circle,
        //     positiveCallback: () {
              clear();
              selectedAddress.sink.add(response.content);
              if(selectedItem != null){
                selectedItem(response.content);
              }
              getListAddressForm();
              if (!isSimpleNotDismissable) {
                Navigator.pop(context, tempAddress);
              }
            // },
            // positiveText: "OK");
      }
    }
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    tempAdress.drain();
    listAddressForm.drain();
    editAddress.drain();
    selectedAddress.drain();
  }

  Future<void> getListAddressForm({Function(MyAddress p1) selectedItem}) async {
    listAddressForm.sink.add(null);
    var response = await _repository.getListAddress();
    var mySelected = selectedAddress.stream.value;
    if (response.content is List) {
      List<MyAddress> mainList =
          ObjectUtils.parseToObjectList<MyAddress>(response.content) ??
              <MyAddress>[];

      if (mainList.isNotEmpty) {
        _setSelected(mySelected, mainList, selectedItem);
      } else {
        listAddressForm.sink.add([]);
        selectedAddress.sink.add(null);
        if (selectedItem != null) {
          selectedItem(null);
        }
      }
    } else {
      selectedAddress.sink.add(null);
      listAddressForm.sink.add([]);
      selectedAddress.sink.add(null);
      if (selectedItem != null) {
        selectedItem(null);
      }
    }

    //   MyAddress(title: "Minha cada", number: "38414536", defaultCard: false),
    //   MyAddress(title: "Casa da vizinha", number: "38414536", defaultCard: true)
    // ]);
  }

  void _setSelected(MyAddress mySelected, List<MyAddress> mainList,
      Function(MyAddress p1) selectedItem) {
    if (mySelected == null) {
      mySelected = mainList.first;
    }
    mySelected.isMain = true;
    selectedAddress.sink.add(mySelected);

    mainList.forEach((element) {
      if (mySelected?.id == element?.id) {
        mySelected.isMain = true;
        mainList[mainList.indexOf(element)] = mySelected;
      } else {
        element.isMain = false;
        mainList[mainList.indexOf(element)] = element;
      }
    });

    if (selectedItem != null) {
      selectedItem(mySelected);
    }
    listAddressForm.sink.add(mainList);
  }

  Future<void> deleteAddress(BuildContext context, MyAddress myAddress, Function onSuccess) async {
    showLoading(true);
    var response = await _repository.deleteAddress(myAddress);
    showLoading(false);
    if (response?.error != null) {
      showGenericDialog(
          context: context,
          title: "Erro",
          description: response.error ?? "Sem resposta",
          iconData: Icons.error,
          positiveCallback: () {},
          positiveText: "OK");
    } else {

        selectedAddress.sink.add(null);



      getListAddressForm(selectedItem: (text){
        onSuccess();
      });
    }
  }

  Future<void> setMainAddress(
      BuildContext context, MyAddress myAddress, Function onSuccess) async {
    List<MyAddress> mainList = ObjectUtils.parseToObjectList<MyAddress>(
            listAddressForm.stream.value) ??
        <MyAddress>[];

    _setSelected(myAddress, mainList, null);
    onSuccess();
    // showLoading(true);
    // var response = await _repository.setMainAddress(myAddress);
    // showLoading(false);
    // if (response?.error != null) {
    //   showGenericDialog(context:context,
    //       title: "Erro",
    //       description: response.error ?? "Sem resposta",
    //       iconData: Icons.error,
    //       positiveCallback: () {},
    //       positiveText: "OK");
    // }else{
    //   getListAddressForm();
    //   onSuccess();
    // }
  }

  void clear() {
    tempAdress.sink.add(MyAddress());
    cepController.clear();
    streetController.clear();
    numberController.clear();
    complementController.clear();
    neighboorhoodController.clear();
    cityController.clear();
    stateController.clear();
  }

  void setEditableAddress(MyAddress data) {
    tempAdress.sink.add(data);
    cepController.text = data.postal;
    controllerTitle.text = data.title;
    streetController.text = data.myAddress;
    numberController.text = data.num;
    complementController.text = data.complement;
    neighboorhoodController.text = data.neighborhood;
    cityController.text = data.nameRegion;
    stateController.text = data.uf;
  }

  // void getAddressByGeoLoation(BuildContext context) {
  //   var progress = ProgressHUD.of(context);
  //   progress.showWithText('Buscando endereço');
  //   LocationUtils.openLocation(context).then((value) {
  //     progress.dismiss();
  //     if (value != null) {
  //       var myAddress = MyAddress();
  //       myAddress.myAddress = value.addressLine;
  //       myAddress.nameRegion = value.locality ?? value.subAdminArea ?? "";
  //       myAddress.postal = value.postalCode;
  //       myAddress.neighborhood = value.subLocality;
  //       myAddress.latitude = value?.coordinates?.latitude?.toString();
  //       myAddress.longitude = value?.coordinates?.longitude?.toString();
  //       myAddress.uf = value.adminArea;
  //       myAddress.num = value.subThoroughfare;
  //
  //       setEditableAddress(myAddress);
  //     } else {
  //       Flushbar(
  //         flushbarStyle: FlushbarStyle.GROUNDED,
  //         flushbarPosition: FlushbarPosition.TOP,
  //         backgroundColor: AppThemeUtils.colorPrimary,
  //         message: "Não encontramos sua localização tente novamente",
  //         icon: Icon(
  //           Icons.info_outline,
  //           size: 28.0,
  //           color: AppThemeUtils.whiteColor,
  //         ),
  //         duration: Duration(seconds: 5),
  //       )..show(context);
  //     }
  //   });
  // }
}
