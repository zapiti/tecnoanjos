import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:geocoder/geocoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search_cep/search_cep.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/models/page/response_paginated.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/myaddress/model/my_address.dart';

import 'package:tecnoanjosclient/app/utils/object/object_utils.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/utils.dart';

import 'core/address_repository.dart';


class AddressBloc extends Disposable {
  var listAddressInfo = BehaviorSubject<ResponsePaginated>();
  var _listTempAddress = List<MyAddress>.from([]);
  var _repository = Modular.get<AddressRepository>();
  var myAddress = BehaviorSubject<MyAddress>.seeded(MyAddress());

  var hideListAddress = BehaviorSubject<bool>();

  Future<MyAddress> searchRegionByName(
      BuildContext context, Address adddress, String subAdminArea) async {
  //  showLoading(true);

    // var result = await _repository.getRegionByName(subAdminArea);
 //   showLoading(false);
    // var listRegions = ObjectUtils.parseToObjectList<RegionAttendance>(
    //     result.content ?? <RegionAttendance>[]);
    var calling = myAddress.stream.value ?? MyAddress();

    calling.nameRegion = adddress.locality ?? adddress.subAdminArea ?? "";
    calling.myAddress = Utils.addressFormat(adddress);
    calling.latitude = adddress.coordinates.latitude.toString();
    calling.longitude = adddress.coordinates.longitude.toString();
    calling.postal = adddress.postalCode;
    calling.neighborhood = adddress.subLocality;

    calling.num = adddress.subThoroughfare;
    calling.uf = adddress.adminArea;
    calling.longitude = adddress.coordinates.longitude.toString();

    myAddress.sink.add(calling);
    return calling;
  }

  getListAddress({int page = 0, bool isFilter = false}) async {
    if (page == 0 || isFilter) {
      listAddressInfo.sink.add(null);
      _listTempAddress.clear();
    }
    var result = await _repository.getListAddress(page: page);
    var listTemp = List<MyAddress>.from([]);
    if (result.error == null) {
      listTemp.addAll(ObjectUtils.parseToObjectList<MyAddress>(result.content));
    }
    if (listTemp.length > 0) {
      hideListAddress.sink.add(false);
    } else {
      hideListAddress.sink.add(true);
    }

    _listTempAddress.addAll(listTemp);
    _listTempAddress = _listTempAddress.toSet().toList();

    result.content = (listTemp);

    await Future.delayed(
        Duration(milliseconds: 100), () => listAddressInfo.sink.add(result));
  }

  saveTitle(String title) {
    var calling = myAddress.stream.value;
    calling.title = title;
    myAddress.sink.add(calling);
  }

  void saveNeighborhood(String neighborhood) {
    var calling = myAddress.stream.value;
    calling.neighborhood = neighborhood;
    myAddress.sink.add(calling);
  }

  void saveCep(BuildContext context, String postal,
      Function(MyAddress) callCalling,{bool ignoreCondition = false}) async {
    var calling = myAddress.stream.value ?? MyAddress();
    if (postal != calling.postal || ignoreCondition) {
      calling.postal = postal;
      if (postal.length >= 7) {
        final viaCepSearchCep = ViaCepSearchCep();

        final infoCepJSON = await viaCepSearchCep.searchInfoByCep(cep: postal);
        var result = infoCepJSON.getOrElse(() => null);
        if (result != null) {
          calling.nameRegion = result?.localidade;
          //  calling.postal = Utils.removeMask(result?.cep);
          calling.myAddress = result?.logradouro;
          calling.neighborhood = result?.bairro;
          calling.nameRegion = result?.localidade;
          calling.uf = result?.uf;
        }else{
          calling = MyAddress();
          calling.postal = postal;
        }
        callCalling(calling);

        //var result2 = await _repository.getRegionByName(calling.nameRegion);

        // var listRegions = ObjectUtils.parseToObjectList<RegionAttendance>(
        //     result2.content ?? <RegionAttendance>[]);
        //
        // calling.codRegion = listRegions.length > 0 ? listRegions.first?.id : 0;
        // calling.nameRegion = listRegions.length > 0
        //     ? "${listRegions.first.name}"
        //     : "";
      }

      // return MyAddress(postal: result?.cep,myAddress: result?.logradouro,neighborhood: result?.bairro,nameRegion: result?.localidade);
      myAddress.sink.add(calling);
    }
  }

  void savePostalCode(String postal) {
    var calling = myAddress.stream.value;
    calling.postal = postal;
    myAddress.sink.add(calling);
  }

  void saveNum(String num) {
    var calling = myAddress.stream.value;
    calling?.num = num;
    myAddress.sink.add(calling);
  }

  void saveUf(String uf) {
    var calling = myAddress.stream.value;
    calling.uf = uf;
    myAddress.sink.add(calling);
  }

  void saveCity(String city) {
    var calling = myAddress.stream.value;
    calling.nameRegion = city;
    calling.codRegion = null;
    myAddress.sink.add(calling);
  }

  void saveAddres(String address) {
    var calling = myAddress.stream.value;
    calling.myAddress = address;
    myAddress.sink.add(calling);
  }

  void saveCityComplement(String complement) {
    var calling = myAddress.stream.value;
    calling?.complement = complement;
    myAddress.sink.add(calling);
  }

  Future<void> createNewAddress(
      BuildContext context, Function(MyAddress) onSave) async {
    showLoading(true);
    var result = await _repository.saveAddress(myAddress.stream.value);
    showLoading(false);
    if (result.error == null) {
      myAddress.sink.add(MyAddress());
      getListAddress();
      FocusScope.of(context).requestFocus(FocusNode());
      if (onSave != null) {
        onSave(result.content);
      }
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

  void editarNewAddress(BuildContext context, onSave) async {
    showLoading(true);
    var result = await _repository.editAddress(myAddress.stream.value);
    showLoading(false);
    if (result.error == null) {
      myAddress.sink.add(MyAddress());
      getListAddress();
      if (onSave != null) {
        onSave(myAddress.stream.value);
      }
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

  Future<void> removeAddress(BuildContext context, MyAddress address) async {
    showLoading(true);
    var result = await _repository.deleteAddress(address);
    showLoading(false);
    if (result.error == null) {
      myAddress.sink.add(MyAddress());
      getListAddress();
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

  void deleteAddress(
      BuildContext context, MyAddress address, VoidCallback positive) {
    showGenericDialog(
        context: context,
        title: StringFile.aviso,
        description: StringFile.desejaDeletar,
        iconData: Icons.error_outline,
        positiveCallback: () {
          positive();
        },
        negativeCallback: () {},
        positiveText: StringFile.ok);
  }

  @override
  void dispose() {
    listAddressInfo?.drain();
    _listTempAddress.clear();

    myAddress.drain();
    hideListAddress.drain();
  }
}
