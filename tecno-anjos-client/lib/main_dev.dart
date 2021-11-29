import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';

import 'main.dart';
void main() {
  Flavor.create(
    Environment.dev,
    color: Colors.green,
    name: 'DEVELOPMENT',
    properties: {
      Keys.apiUrl: 'http://18.228.67.67:3000',
      Keys.apiKey: '',
      firebaseKey: 'DEVELOPMENT',
      actualVersion:"2.9.4",
      paymentUrl: 'http://18.228.67.67:4000',
      googleClientId: "530042554687-as9dn4hdbi6usvim6bfo27to77456u5o.apps.googleusercontent.com"
    },
  );
  setupApp();
}
