import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:tecnoanjosclient/app/core/network/network_info.dart';
import 'package:tecnoanjosclient/app/utils/image/image_path.dart';
import 'package:tecnoanjosclient/app/utils/theme/app_theme_utils.dart';


class ConnectionPage extends StatefulWidget {
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final DataConnectionChecker dataConnectionChecker = DataConnectionChecker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void animate() async {
    // _animationController.repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DataConnectionStatus>(
        initialData: DataConnectionStatus.connected,
        stream: NetworkInfoImpl(dataConnectionChecker).listenConnection,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? SizedBox()
              : (snapshot.data == DataConnectionStatus.connected)
                  ? SizedBox()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              ImagePath.conection,
                              height: 200,
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 30),
                                child: Text(
                                  "Conexão indisponível.\nVerifique e tente novamente!",
                                  textAlign: TextAlign.center,
                                  style: AppThemeUtils.normalSize(
                                      color: AppThemeUtils.colorPrimary,
                                      fontSize: 18),
                                )),
                          ]));
        });
  }
}
