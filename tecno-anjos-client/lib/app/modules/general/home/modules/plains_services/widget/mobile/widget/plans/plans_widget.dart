import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/plains_services/widget/mobile/widget/plans/widget/itens_plans_widget.dart';

import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/string/string_file.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

import '../../../payment_bottom_sheet.dart';

class PlansWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
      childCenter: CenterViewAttendance( subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              "Tecnoanjo Premium",
              style: AppThemeUtils.normalBoldSize(
                  color: AppThemeUtils.colorPrimary, fontSize: 22),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "R\$30,99/mês",
              style: AppThemeUtils.normalBoldSize(),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Faça mais , por muito menos. Contrate nosso plano de serviço mensal para ter acesso a descontos maravilhosos",
              style: AppThemeUtils.normalSize(),
            ),
          ),
          ItensPlansWidget(
            pathImage: ImagePath.economy,
            title: "Economize em todos os chamados",
            description:
                "Com nosso plano você tem 20% de desconto em todos os chamados que você fizer independete do valor do chamado",
          ),
          ItensPlansWidget(
            pathImage: ImagePath.suport,
            title: "Suporte 24 horas",
            description:
                "Você consegue acesso e suporte 24 horas em atendimentos presenciais ou remotos",
          ),
          ItensPlansWidget(
            pathImage: ImagePath.preference,
            title: "Atendimento preferencial",
            description: "Você tem preferencia ao fazer um chamado!",
          ),
        ],
      )),
      childBottom: Container(
          padding: EdgeInsets.all(15),
          child: ElevatedButton(
            onPressed: () {
              showBottomSheetPayment(
                  context: context,
                  title: "Tecnoanjo premium R\$30,99/mês",
                  description: StringFile.planoDescription,
                  subTitle: StringFile.planoSubtitle);
            },
            style: ElevatedButton.styleFrom(
                primary: AppThemeUtils.colorPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: AppThemeUtils.colorError))),
            child: Container(
                height: 45,
                child: Center(
                    child: Text(
                  StringFile.contratarPlano,
                  style:
                      AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
                ))),
          )),
    );
  }
}
