
import 'package:flutter/material.dart';

class ReloadWithConnectionView extends StatelessWidget {
  final Widget child;

  ReloadWithConnectionView(this.child);

  @override
  Widget build(BuildContext context) {
    return  child;

    // return ConnectivityBuilder(
    //     builder: (context, isConnected, status) =>
    //     !(isConnected ?? true) ? SizedBox() : child);
  }
}
