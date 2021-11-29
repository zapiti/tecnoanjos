import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:tecno_anjos_landing/app/components/build_bottom_landing_page.dart';
import 'package:tecno_anjos_landing/app/modules/landing_page/home/home_view.dart';
import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickSupportView extends StatefulWidget {
  @override
  _QuickSupportViewState createState() => _QuickSupportViewState();
}

class _QuickSupportViewState extends State<QuickSupportView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
          top: 40,
        ),
        child: ResponsiveGridRow(children: [
          ResponsiveGridCol(
            xs: 12,
            md: 12,
            xl: 6,
            sm: 12,
            lg: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 400,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 700,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        width: 700,
                                        child: Text(
                                          "Aprenda aqui o passo a\npasso, para ser atendido\npelos TecnoAnjos\nremotamente!",
                                          style: AppThemeUtils.normalBoldSize(
                                              fontSize: 42,
                                              color: AppThemeUtils.whiteColor),
                                        ))
                                  ]))),
                    ],
                  )),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 12,
            xl: 6,
            sm: 12,
            lg: 6,
            child: Container(
              height: 378,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Image.asset(
                ImagePath.imagelandingCloudPage,
                height: 378,
                width: 575,
              ),
            ),
          ),
          space(height: 150),
          ResponsiveGridCol(
            xs: 12,
            md: 12,
            xl: 6,
            sm: 12,
            lg: 6,
            child: Container(
              height: 318,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 700,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    width: 700,
                                    child: Text(
                                      "São 5 passos práticos para ser atendido de forma tranquila, prática e segura.",
                                      style: GoogleFonts.roboto(
                                          fontSize: 40,
                                          color: AppThemeUtils.colorPrimary,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ]))),
                  Container(
                      width: 700,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: Text(
                        "Siga os passos abaixo, ou assista o vídeo ao lado.",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.roboto(
                            fontSize: 20, color: AppThemeUtils.black),
                      )),
                ],
              ),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 12,
            xl: 6,
            sm: 12,
            lg: 6,
            child: Container(
              height: 318,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  height: 318,
                  child: Card(
                      color: Colors.grey[100],
                      child: Container(
                          height: 318,
                          width: 530,
                          child: Card(
                              color: Colors.grey[300],
                              child: Container(
                                  height: 100,
                                  width: 300,
                                  child: Center(
                                      child: Image.asset(
                                    ImagePath.imagePlay,
                                    height: 318,
                                    width: 530,
                                  ))))))),
            ),
          ),
          space(height: 50),
          ResponsiveGridCol(
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: titleNumber(
                1,
                "",
                title:InkWell(onTap: (){
                  _launchURL();
                  },
                    child:  RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "Baixe nosso instalador de acesso remoto, ",
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.colorPrimary, fontSize: 24),
                        children: <TextSpan>[
                          TextSpan(
                              text: "clicando aqui.",
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.colorPrimary,
                                  decoration: TextDecoration.underline,
                                  fontSize: 24),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                _launchURL();
                              })
                        ]))),
              ),
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: titleNumber(
                2,
                "O arquivo irá aparecer no canto inferior esquerdo do seu navegador, e para abri-lo, basta clicar nele. Caso não apareça, o arquivo baixou provavelmente estará na pasta “Downloads” de seu computador. Encontre-o, e dê dois cliques para abrir-lo.",
              ),
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Image.asset(ImagePath.teamviewer11),
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: titleNumber(
                3,
                "",
                title: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text:
                            "Quando você clicar nele, serão exibidos os termos de uso do software; aceite-os para poder realizar a instalação. Após, aparecerá uma caixa de perguntas, com o seguinte texto: Deseja permitir que esse arquivo faça alterações no seu dispositivo? Marque a Opção  \"",
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.colorPrimary, fontSize: 24),
                        children: <TextSpan>[
                          TextSpan(
                              text: "SIM",
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.colorPrimary,
                                  fontSize: 24)),
                          TextSpan(
                            text:
                                "\"",
                            style: AppThemeUtils.normalSize(
                                color: AppThemeUtils.colorPrimary,
                                fontSize: 24),
                          )
                        ])),
              ),
            ),
          ),
          ResponsiveGridCol(
            xs: 6,
            md:6,
            xl: 6,
            sm: 6,
            lg: 6,
            child: Container(
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              alignment: Alignment.centerRight,
              child: Image.asset(ImagePath.teamviewer2_1),
            ),
          ),
          ResponsiveGridCol(
            xs: 6,
            md:6,
            xl: 6,
            sm: 6,
            lg: 6,
            child: Container(
              height: 300,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              alignment: Alignment.centerLeft,
              child: Image.asset(ImagePath.teamviewer2),
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              height: 20,
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: titleNumber(
                4,
                "Com isso, uma pequena tela será exibida, contendo duas informações que devem ser passadas ao seu Tecnoanjo: 'ID' e 'SENHA'. Elas permitem ao Tecnoanjo acessar seu computador via internet (apenas durante o momento do atendimento), para solucionar seu chamado. Envie o 'ID' e 'SENHA' para o Tecnoanjo por meio do chat no aplicativo.",
                title: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text:
                            "Com isso, uma pequena tela será exibida, contendo duas informações que devem ser passadas ao seu Tecnoanjo:\"",
                        style: AppThemeUtils.normalSize(
                            color: AppThemeUtils.colorPrimary, fontSize: 24),
                        children: <TextSpan>[
                          TextSpan(
                              text: "ID",
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.colorPrimary,
                                  fontSize: 24)),
                          TextSpan(
                              text: "\" e \"",
                              style: AppThemeUtils.normalSize(
                                  color: AppThemeUtils.colorPrimary,
                                  fontSize: 24)),
                          TextSpan(
                              text: "SENHA",
                              style: AppThemeUtils.normalBoldSize(
                                  color: AppThemeUtils.colorPrimary,
                                  fontSize: 24)),
                          TextSpan(
                            text:
                                "\". Elas permitem ao Tecnoanjo acessar seu computador via internet (apenas durante o momento do atendimento), para solucionar seu chamado. Envie o \"ID\" e \"SENHA\" para o Tecnoanjo por meio do chat no aplicativo.",
                            style: AppThemeUtils.normalSize(
                                color: AppThemeUtils.colorPrimary,
                                fontSize: 24),
                          )
                        ])),
              ),
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              height: 450,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Image.asset(ImagePath.teamviewer3),
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: titleNumber(
                5,
                "Agora, é só aguardar seu Tecnoanjo falar com você!",
              ),
            ),
          ),
          ResponsiveGridCol(
            child: Container(
              height: 450,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Image.asset(ImagePath.teamviewer4),
            ),
          ),

          space(height: 80),
          ResponsiveGridCol(
            child: Container(
                color: AppThemeUtils.colorPrimary,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Text(
                  "Fácil, né? Lembrando que o técnico possuirá acesso ao seu computador apenas durante o atendimento. Fique tranquilo(a)!",
                  textAlign: TextAlign.center,
                  style: AppThemeUtils.normalBoldSize(
                      color: AppThemeUtils.whiteColor, fontSize: 40),
                )),
          ),
          ResponsiveGridCol(
            child: Container(
              height: 670,
              // child: loadWebView(url: AwsConfiguration.URL_TO_FORM),
            ),
          ),
          // buildForm(context),
          ResponsiveGridCol(
            child: buildBottomTecno(context),
          ),
        ]));
  }
}

titleNumber(int number, String description, {Widget title}) {
  return Row(
    children: [
      SizedBox(
        width: 80,
      ),
      new Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
            border: Border.all(color: AppThemeUtils.colorPrimary, width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Text("$number",
            style: AppThemeUtils.normalSize(
                color: AppThemeUtils.colorPrimary, fontSize: 32)),
      ),
      Expanded(
          child: new Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(13.0),
        child: title ??
            Text(
              "$description",
              style: AppThemeUtils.normalSize(
                  color: AppThemeUtils.colorPrimary, fontSize: 24),
            ),
      )),
      SizedBox(
        width: 80,
      ),
    ],
  );
}_launchURL() async {
  const url = 'https://www.898.tv/tecnoanjos';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
