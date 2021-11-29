import 'package:tecnoanjos_franquia/app/models/pairs.dart';
import 'package:flutter/material.dart';

class Constants {
  static Pairs prospect = Pairs('Editar Prospect', Icons.edit,third: 1);
  static Pairs cnae = Pairs('Atualizar CNAE', Icons.autorenew,four: 2);

  static List<Pairs> choices = <Pairs>[prospect, cnae];
}
