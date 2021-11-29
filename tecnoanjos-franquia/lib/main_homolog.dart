import 'package:flavor/flavor.dart';
import 'package:flutter/material.dart';

import 'main.dart';

void main() {
  Flavor.create(
    Environment.alpha,
    color: Colors.orange,
    name: 'HOMOLOGATION',
    properties: {
      Keys.apiUrl: 'http://18.229.102.3:3000',
      Keys.apiKey: '',
      firebaseKey: 'HOMOLOGATION',
      actualVersion:"2.6.9",
      paymentUrl: 'http://18.229.102.3:4000'
    },
  );
  setupApp();
}
