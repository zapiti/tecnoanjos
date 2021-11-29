import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/components/atendimento/center_view_attendance.dart';
import 'package:tecnoanjosclient/app/components/atendimento/view_atendimento.dart';
import 'package:tecnoanjosclient/app/modules/general/home/modules/plains_services/widget/mobile/widget/services/widget/itens_services_widget.dart';

import 'package:tecnoanjosclient/app/utils/string/string_file.dart';

import '../../../payment_bottom_sheet.dart';
import '../title_hours_widget.dart';

class ServicesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewAttendanceWidget(
      childTop: TitleHoursWidget("0 Horas"),
      topFixSized: 35,
      childCenter: CenterViewAttendance(subtitle:
      Column(
        children: [
          ItensServicesWidget(
            title: "50 horas",
            description: "Acesso presencial apenas",
            pricingParcel: "3 x de R\$16,00",
            pricingTotal: "Á vista R\$ 45,00",
            action: () {
              showBottomSheetPayment(
                  context: context,
                  title: "50 horas por 3 x de R\$16,00",
                  description: StringFile.descricaoServicos +
                      "50 horas por 3 x de R\$16,00" +
                      StringFile.descricaoServicosPT2,
                  subTitle:
                      StringFile.subDescricao + "50 horas por 3 x de R\$16,00");
            },
            recomendado: false,
          ),
          ItensServicesWidget(
            title: "150 horas",
            description: "Acesso presencial e remoto",
            pricingParcel: "3 x de R\$30,00",
            pricingTotal: "Á vista R\$ 130,00",
            action: () {
              showBottomSheetPayment(
                  context: context,
                  title: "150 horas por 3 x de R\$30,00",
                  description: StringFile.descricaoServicos +
                      "150 horas por 3 x de R\$30,00" +
                      StringFile.descricaoServicosPT2,
                  subTitle: StringFile.subDescricao +
                      "150 horas por 3 x de R\$30,00");
            },
            recomendado: true,
          ),
          ItensServicesWidget(
            title: "500 horas",
            description: "Acesso presencial apenas",
            pricingParcel: "3 x de R\$150,00",
            pricingTotal: "Á vista R\$ 420,00",
            action: () {
              showBottomSheetPayment(
                  context: context,
                  title: "500 horas por 3 x de R\$150,00",
                  description: StringFile.descricaoServicos +
                      "500 horas por 3 x de R\$150,00" +
                      StringFile.descricaoServicosPT2,
                  subTitle: StringFile.subDescricao +
                      "500 horas por 3 x de R\$150,00");
            },
            recomendado: false,
          ),
          ItensServicesWidget(
            title: "1000 horas",
            description: "Acesso presencial apenas",
            pricingParcel: "3 x de R\$310,00",
            pricingTotal: "Á vista R\$ 900,00",
            action: () {
              showBottomSheetPayment(
                  context: context,
                  title: "1000 horas por 3 x de R\$310,00",
                  description: StringFile.descricaoServicos +
                      "1000 horas por 3 x de R\$310,00" +
                      StringFile.descricaoServicosPT2,
                  subTitle: StringFile.subDescricao +
                      "1000 horas por 3 x de R\$310,00");
            },
            recomendado: true,
          ),
        ],
      )),
    );
  }
}
