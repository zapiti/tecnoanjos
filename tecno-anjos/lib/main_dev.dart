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
      actualVersion:"2.9.2",
      paymentUrl: 'http://18.228.67.67:4000'
    },
  );
  setupApp();
}
