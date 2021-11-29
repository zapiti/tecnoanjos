import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_generic.dart';
import 'package:tecnoanjosclient/app/components/dialog/dialog_loading.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/sugestion/repository/sugestion_repository.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class SugestionBloc extends Disposable {
  final _repository = Modular.get<SugestionRepository>();

  @override
  void dispose() {}

  Future<void> makeSugestion(BuildContext context, String text,
      bool isSugestion, Function onSucess) async {
    showLoading(true);

    var result = await _repository.creatSuggestion(text, isSugestion);
    showLoading(false);

    if (result.error == null) {
      showGenericDialog(context:context,
          title: StringFile.obrigado,
          description: isSugestion
              ? StringFile.obrigadoPelaSugestao
              : StringFile.obrigadoPelaCritica,
          imagePath: ImagePath.imageThanks,
          color: AppThemeUtils.whiteColor,
          topColor: AppThemeUtils.whiteColor, positiveCallback: () {
        onSucess();
      }, positiveText: StringFile.OK);
    } else {
      showGenericDialog(context:context,
          title: StringFile.opps,
          description: "${result.error}",
          iconData: Icons.error_outline,
          positiveCallback: () {},
          positiveText: StringFile.OK);
    }
  }
}
