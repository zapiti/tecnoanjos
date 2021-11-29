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
      actualVersion:"2.7.0",
      paymentUrl: 'http://18.229.102.3:4000',
      googleClientId: "530042554687-s6qg8d5arb7ua3nf1cdolp415375c86e.apps.googleusercontent.com"
    },
  );
  setupApp();
}
