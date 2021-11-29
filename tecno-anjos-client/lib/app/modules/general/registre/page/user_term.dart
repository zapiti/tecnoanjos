import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';

class UserTerm extends StatefulWidget {
  final String title;

  UserTerm(this.title);

  @override
  _UserTermState createState() => _UserTermState();
}

class _UserTermState extends State<UserTerm> {
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: AppThemeUtils.normalSize(color: AppThemeUtils.whiteColor),
          ),
          automaticallyImplyLeading: true,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      child: RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                            text: "",
                            style: AppThemeUtils.normalSize(
                                color: AppThemeUtils.black, fontSize: 26),
                            children: <TextSpan>[
                              TextSpan(
                                  text: widget.title + "\n\n",
                                  style: AppThemeUtils.normalBoldSize(
                                      fontSize: 26)),
                              TextSpan(
                                  text: titleTermOneDescription,
                                  style:
                                  AppThemeUtils.normalSize(fontSize: 16)),
                              TextSpan(
                                  text: titleTermTwoTitle,
                                  style: AppThemeUtils.normalBoldSize(
                                      fontSize: 26)),
                              TextSpan(
                                  text: titleTermTwoDescription,
                                  style:
                                  AppThemeUtils.normalSize(fontSize: 16)),
                            ],
                          ))),
                ),
                /*Text(
                          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?',
                          style: TextStyle(
                              fontSize: 14,
                              height: 1.2,
                              fontFamily: 'Metropolis_Regular',
                              color: const Color(0xff5C5C5C)),
                        ),*/
              ),
            ), //Text

            // Accept Button
            new Container(
              margin: const EdgeInsets.only(
                  left: 30.0, right: 30.0, bottom: 0.0, top: 10),
              alignment: Alignment.center,
              child: ElevatedButton(


                style: ElevatedButton.styleFrom(
                  primary: AppThemeUtils.colorPrimary,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                  ),),
                onPressed: () =>
                {
                  Navigator.pop(buildContext, true),
                },
                child: new Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 15.0,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: Text(
                          "Aceitar termos",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Metropolis_Regular',
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), // Next Button

            Container(
              margin: EdgeInsets.only(top: 0, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style:ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: () {
                      Navigator.pop(buildContext, false);
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 2, right: 5, bottom: 2),
                      child: new Text(
                        "Recusar",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14.0,
                          fontFamily: 'Metropolis_Regular',
                          color: AppThemeUtils.colorPrimary,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

Future<bool> goToTerm(String title, BuildContext context) async {
  var group = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserTerm(title)),
  );
  return group;
}

//var titleTermOneTitle = "Política Privacidade\n\n";
var titleTermOneDescription =
    "A sua privacidade é importante para nós. É política do Tecno anjos respeitar a sua privacidade em relação a qualquer informação sua que possamos coletar no site Tecno anjos, e outros sites que possuímos e operamos. " +
        "Solicitamos informações pessoais apenas quando realmente precisamos delas para lhe fornecer um serviço. Fazemo-lo por meios justos e legais, com o seu conhecimento e consentimento. Também informamos por que estamos coletando e como será usado. " +
        "Apenas retemos as informações coletadas pelo tempo necessário para fornecer o serviço solicitado. Quando armazenamos dados, protegemos dentro de meios comercialmente aceitáveis ​​para evitar perdas e roubos, bem como acesso, divulgação, cópia, uso ou modificação não autorizados. " +
        "Não compartilhamos informações de identificação pessoal publicamente ou com terceiros, exceto quando exigido por lei. " +
        "O nosso site pode ter links para sites externos que não são operados por nós. Esteja ciente de que não temos controle sobre o conteúdo e práticas desses sites e não podemos aceitar responsabilidade por suas respectivas políticas de privacidade. " +
        "Você é livre para recusar a nossa solicitação de informações pessoais, entendendo que talvez não possamos fornecer alguns dos serviços desejados. " +
        "O uso continuado de nosso site será considerado como aceitação de nossas práticas em torno de privacidade e informações pessoais. Se você tiver alguma dúvida sobre como lidamos com dados do usuário e informações pessoais, entre em contacto connosco.";

var titleTermTwoTitle = "\n\nPolítica de Cookies Tecno anjos\n\n";
var titleTermTwoDescription = "O que são cookies?" +
    "Como é prática comum em quase todos os sites profissionais, este site usa cookies, que são pequenos arquivos baixados no seu computador, para melhorar sua experiência. Esta página descreve quais informações eles coletam, como as usamos e por que às vezes precisamos armazenar esses cookies. Também compartilharemos como você pode impedir que esses cookies sejam armazenados, no entanto, isso pode fazer o downgrade ou 'quebrar' certos elementos da funcionalidade do site." +
    "Como usamos os cookies?" +
    "Utilizamos cookies por vários motivos, detalhados abaixo. Infelizmente, na maioria dos casos, não existem opções padrão do setor para desativar os cookies sem desativar completamente a funcionalidade e os recursos que eles adicionam a este site. É recomendável que você deixe todos os cookies se não tiver certeza se precisa ou não deles, caso sejam usados ​​para fornecer um serviço que você usa." +
    "Desativar cookies" +
    "Você pode impedir a configuração de cookies ajustando as configurações do seu navegador (consulte a Ajuda do navegador para saber como fazer isso). Esteja ciente de que a desativação de cookies afetará a funcionalidade deste e de muitos outros sites que você visita. A desativação de cookies geralmente resultará na desativação de determinadas funcionalidades e recursos deste site. Portanto, é recomendável que você não desative os cookies." +
    "Cookies que definimos" +
    "Cookies relacionados à conta" +
    "Se você criar uma conta connosco, usaremos cookies para o gerenciamento do processo de inscrição e administração geral. Esses cookies geralmente serão excluídos quando você sair do sistema, porém, em alguns casos, eles poderão permanecer posteriormente para lembrar as preferências do seu site ao sair." +
    "Cookies relacionados ao login" +
    "Utilizamos cookies quando você está logado, para que possamos lembrar dessa ação. Isso evita que você precise fazer login sempre que visitar uma nova página. Esses cookies são normalmente removidos ou limpos quando você efetua logout para garantir que você possa acessar apenas a recursos e áreas restritas ao efetuar login." +
    "Cookies relacionados a boletins por e-mail" +
    "Este site oferece serviços de assinatura de boletim informativo ou e-mail e os cookies podem ser usados ​​para lembrar se você já está registrado e se deve mostrar determinadas notificações válidas apenas para usuários inscritos / não inscritos." +
    "Pedidos processando cookies relacionados" +
    "Este site oferece facilidades de comércio eletrônico ou pagamento e alguns cookies são essenciais para garantir que seu pedido seja lembrado entre as páginas, para que possamos processá-lo adequadamente." +
    "Cookies relacionados a pesquisas" +
    "Periodicamente, oferecemos pesquisas e questionários para fornecer informações interessantes, ferramentas úteis ou para entender nossa base de usuários com mais precisão. Essas pesquisas podem usar cookies para lembrar quem já participou numa pesquisa ou para fornecer resultados precisos após a alteração das páginas." +
    "Cookies relacionados a formulários" +
    "Quando você envia dados por meio de um formulário como os encontrados nas páginas de contacto ou nos formulários de comentários, os cookies podem ser configurados para lembrar os detalhes do usuário para correspondência futura." +
    "Cookies de preferências do site" +
    "Para proporcionar uma ótima experiência neste site, fornecemos a funcionalidade para definir suas preferências de como esse site é executado quando você o usa. Para lembrar suas preferências, precisamos definir cookies para que essas informações possam ser chamadas sempre que você interagir com uma página for afetada por suas preferências." +
    "Cookies de Terceiros" +
    "Em alguns casos especiais, também usamos cookies fornecidos por terceiros confiáveis. A seção a seguir detalha quais cookies de terceiros você pode encontrar através deste site." +
    "Este site usa o Google Analytics, que é uma das soluções de análise mais difundidas e confiáveis ​​da Web, para nos ajudar a entender como você usa o site e como podemos melhorar sua experiência. Esses cookies podem rastrear itens como quanto tempo você gasta no site e as páginas visitadas, para que possamos continuar produzindo conteúdo atraente." +
    "Para mais informações sobre cookies do Google Analytics, consulte a página oficial do Google Analytics." +
    "As análises de terceiros são usadas para rastrear e medir o uso deste site, para que possamos continuar produzindo conteúdo atrativo. Esses cookies podem rastrear itens como o tempo que você passa no site ou as páginas visitadas, o que nos ajuda a entender como podemos melhorar o site para você." +
    "Periodicamente, testamos novos recursos e fazemos alterações subtis na maneira como o site se apresenta. Quando ainda estamos testando novos recursos, esses cookies podem ser usados ​​para garantir que você receba uma experiência consistente enquanto estiver no site, enquanto entendemos quais otimizações os nossos usuários mais apreciam." +
    "À medida que vendemos produtos, é importante entendermos as estatísticas sobre quantos visitantes de nosso site realmente compram e, portanto, esse é o tipo de dados que esses cookies rastrearão. Isso é importante para você, pois significa que podemos fazer previsões de negócios com precisão que nos permitem analizar nossos custos de publicidade e produtos para garantir o melhor preço possível." +
    "Compromisso do Usuário" +
    "O usuário se compromete a fazer uso adequado dos conteúdos e da informação que o Tecno anjos oferece no site e com caráter enunciativo, mas não limitativo:" +
    "A) Não se envolver em atividades que sejam ilegais ou contrárias à boa fé a à ordem pública;" +
    "B) Não divulgar conteúdo ou propaganda de natureza racista, xenofóbica, apostas online, pornografia ilegal, de apologia ao terrorismo ou contra os direitos humanos;" +
    "C) Não causar danos aos sistemas físicos (hardwares) e lógicos (softwares) do Tecno anjos, de seus fornecedores ou terceiros, para introduzir ou disseminar vírus informáticos ou quaisquer outros sistemas de hardware ou software que sejam capazes de causar danos anteriormente mencionados." +
    "Mais informações" +
    "Esperemos que esteja esclarecido e, como mencionado anteriormente, se houver algo que você não tem certeza se precisa ou não, geralmente é mais seguro deixar os cookies ativados, caso interaja com um dos recursos que você usa em nosso site." +
    "Esta política é efetiva a partir de November/2020.";
