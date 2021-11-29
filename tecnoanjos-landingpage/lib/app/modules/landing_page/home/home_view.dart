import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:tecno_anjos_landing/app/components/build_bottom_landing_page.dart';
import 'package:tecno_anjos_landing/app/components/title_description_image.dart';
import 'package:tecno_anjos_landing/app/configuration/aws_configuration.dart';
import 'package:tecno_anjos_landing/app/utils/image/image_path.dart';
import 'package:tecno_anjos_landing/app/utils/response/response_utils.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_file.dart';
import 'package:tecno_anjos_landing/app/utils/string/string_landingpage_file.dart';
import 'package:tecno_anjos_landing/app/utils/theme/app_theme_utils.dart';
import 'package:video_player/video_player.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  VideoPlayerController _controllerCliente;
  VideoPlayerController _controllerTecno;
  bool isPlayCliente = false;
  bool isPlayTecno = false;

  @override
  void initState() {
    super.initState();
    _controllerCliente = VideoPlayerController.asset(ImagePath.video_cliente)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controllerTecno = VideoPlayerController.asset(ImagePath.video_tecnico)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  ResponsiveGridRow franquiseInfoWidget(BuildContext context) {
    return ResponsiveGridRow(children: [
      space(height: 50),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 700,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                                width: 700,
                                child: Text(
                                  StringLandingPageFile.sejaUmTecnoanjo,
                                  style: GoogleFonts.roboto(
                                      fontSize: 40,
                                      color: AppThemeUtils.whiteColor,
                                      fontWeight: FontWeight.bold),
                                ))
                          ]))),
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
                      child: Container(
                          height: 100,
                          width: 300,
                          child: Center(
                              child: Stack(
                                children: [
                                  Center(
                                    child: _controllerTecno.value.initialized
                                        ? AspectRatio(
                                      aspectRatio:
                                      _controllerTecno.value.aspectRatio,
                                      child: VideoPlayer(_controllerTecno),
                                    )
                                        : Container(),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (isPlayTecno) {
                                          _controllerTecno.pause();
                                          setState(() {
                                            isPlayTecno = false;
                                          });
                                        } else {
                                          _controllerTecno.play();
                                          setState(() {
                                            isPlayTecno = true;
                                          });
                                        }
                                      },
                                      child: Opacity(
                                          opacity: isPlayTecno ? 0 : 0.6,
                                          child: Container(
                                              color: Colors.white,
                                              child: Image.asset(
                                                ImagePath.imagePlay,
                                                height: 318,
                                                width: 530,
                                              )))),
                                ],
                              )))))),
        ),
      ),
      space(height: 50),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
            height: 270,
            padding: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment(0, 0),
            child: Container(
                child: titleDescriptionImageTecno(
                    imagePath: ImagePath.t("1"),
                    subtitle: StringLandingPageFile.negocioDivertido)),
          ),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("2"),
                  subtitle: StringLandingPageFile.capacidade)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("3"),
                  subtitle: StringLandingPageFile.acessoOnline)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("4"),
                  subtitle: StringFile.apoioDaEstruturaComercial)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("5"),
                  subtitle: StringFile.maiorMercado)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("6"),
                  subtitle: StringFile.franquiasObjetivas)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("7"),
                  subtitle: StringLandingPageFile.baixoRisco)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("8"), subtitle: StringFile.semLimites)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("9"),
                  subtitle: StringLandingPageFile.oportunidades)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 3,
        sm: 6,
        lg: 3,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment(0, 0),
          child: Container(
              child: titleDescriptionImageTecno(
                  imagePath: ImagePath.t("10"),
                  subtitle: StringLandingPageFile.ofertas)),
        ),
      ),
      ResponsiveGridCol(
        xs: 12,
        md: 6,
        xl: 6,
        sm: 6,
        lg: 6,
        child: Container(
          height: 270,
          padding: EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    ]);
  }

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
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                          child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 700,
                                        child: Text(
                                          StringLandingPageFile
                                              .naoAcreditaEmAnjo,
                                          style: GoogleFonts.roboto(
                                              fontSize: 40,
                                              color: AppThemeUtils.whiteColor,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ]))),
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
                                          StringLandingPageFile
                                              .naSuaEmpresaOuResidencia,
                                          style: GoogleFonts.roboto(
                                              fontSize: 28,
                                              color: AppThemeUtils.whiteColor),
                                        ))
                                  ]))),
                      Container(
                          width: 700,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RaisedButton(
                                  color: AppThemeUtils.whiteColor,
                                  onPressed: () {
                                    ResponseUtils.launchURL(
                                        AwsConfiguration.URL_TO_CLIENTE);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        StringLandingPageFile
                                            .chameAquiSeuTecnoanjo,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.roboto(
                                            color: AppThemeUtils.colorPrimary,
                                            fontSize: 16),
                                      )),
                                  shape: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide: BorderSide.none),
                                )
                              ])),
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
                                      StringLandingPageFile
                                          .sejaUmClienteTecnoanjo,
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
                        StringLandingPageFile.clienteEtranquiloPq,
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
                          child: Container(
                              height: 100,
                              width: 300,
                              child: Center(
                                  child: Stack(
                                children: [
                                  Center(
                                    child: _controllerCliente.value.initialized
                                        ? AspectRatio(
                                            aspectRatio: _controllerCliente
                                                .value.aspectRatio,
                                            child:
                                                VideoPlayer(_controllerCliente),
                                          )
                                        : Container(),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        if (isPlayCliente) {
                                          _controllerCliente.pause();
                                          setState(() {
                                            isPlayCliente = false;
                                          });
                                        } else {
                                          _controllerCliente.play();
                                          setState(() {
                                            isPlayCliente = true;
                                          });
                                        }
                                      },
                                      child: Opacity(
                                          opacity: isPlayCliente ? 0 : 0.6,
                                          child: Container(
                                              color: Colors.white,
                                              child: Image.asset(
                                                ImagePath.imagePlay,
                                                height: 318,
                                                width: 530,
                                              )))),
                                ],
                              )))))),
            ),
          ),
          space(height: 50),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              width: 700,
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("1"),
                      title: StringLandingPageFile.seguranca,
                      subtitle: StringLandingPageFile.segurancaDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("2"),
                      title: StringLandingPageFile.etica,
                      subtitle: StringLandingPageFile.eticaDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("3"),
                      title: StringLandingPageFile.meritocracia,
                      subtitle: StringLandingPageFile.meritocraciaDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("4"),
                      title: StringLandingPageFile.privacidade,
                      subtitle: StringLandingPageFile.privacidadeDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("5"),
                      title: StringLandingPageFile.responsibilidade,
                      subtitle:
                          StringLandingPageFile.responsibilidadeDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("6"),
                      title: StringLandingPageFile.capacitacao,
                      subtitle: StringLandingPageFile.capacitacaoDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("7"),
                      title: StringLandingPageFile.suporte,
                      subtitle: StringLandingPageFile.suporteDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("8"),
                      title: StringLandingPageFile.conveniencia,
                      subtitle: StringLandingPageFile.convenienciaDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("9"),
                      title: StringLandingPageFile.resultado,
                      subtitle: StringLandingPageFile.resultadoDescription)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 3,
            sm: 6,
            lg: 3,
            child: Container(
              height: 270,
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment(0, 0),
              child: Container(
                  child: titleDescriptionImage(
                      imagePath: ImagePath.f("10"),
                      title: StringLandingPageFile.atendimento,
                      subtitle: StringLandingPageFile.atendimentoDetalhe)),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            xl: 6,
            sm: 6,
            lg: 6,
            child: Container(
              height: 300,
              padding: EdgeInsets.only(left: 80),
              alignment: Alignment(0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 850,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(ImagePath.android),
                          Image.asset(ImagePath.ios)
                        ],
                      )),
                  Container(
                      width: 850,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        StringLandingPageFile.baixeApp,
                        style: GoogleFonts.roboto(
                            fontSize: 40,
                            color: AppThemeUtils.black,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ),
          ),
          space(height: 80),
          ResponsiveGridCol(
            child: Container(
                color: AppThemeUtils.colorPrimary,
                child: franquiseInfoWidget(context)),
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

    // return ScreenTypeLayout(
    //   mobile: HomeContentMobile(),
    //   desktop: HomeContentDesktop(),
    // );
  }
}

ResponsiveGridCol space({double height}) {
  return ResponsiveGridCol(
    child: Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment(0, 0),
    ),
  );
}


