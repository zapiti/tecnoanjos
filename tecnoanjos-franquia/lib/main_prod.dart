import 'package:flavor/flavor.dart';

import 'main.dart';

void main() {
  Flavor.create(
    Environment.production,
    properties: {
      Keys.apiUrl: 'https://api.company.com',
      Keys.apiKey: '',
      firebaseKey: "PRODUCTION",
      actualVersion:"1.0.0",
      paymentUrl: ''
    },
  );
  setupApp();
}
