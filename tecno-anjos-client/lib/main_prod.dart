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
      paymentUrl: '',
      googleClientId: "530042554687-s6qg8d5arb7ua3nf1cdolp415375c86e.apps.googleusercontent.com"
    },
  );
  setupApp();
}
