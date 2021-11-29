import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/modules/general/teste/model/teste.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class ItemTeste extends StatelessWidget {
  final Teste teste;

  const ItemTeste(this.teste);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 200,
      color: Colors.black,
      child: Card(
        child:InkWell(
            onTap: (){},
            child:  Text(
          "Funcriona",
          style: AppThemeUtils.normalSize(),
        )),
      ),
    );
  }
}
