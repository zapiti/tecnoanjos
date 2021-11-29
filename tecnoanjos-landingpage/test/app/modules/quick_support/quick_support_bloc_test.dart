import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tecno_anjos_landing/app/app_module.dart';
import 'package:tecno_anjos_landing/app/modules/quick_support/quick_support_bloc.dart';
import 'package:tecno_anjos_landing/app/modules/quick_support/quick_support_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(QuickSupportModule());
  QuickSupportBloc bloc;

  // setUp(() {
  //     bloc = QuickSupportModule.to.get<QuickSupportBloc>();
  // });

  // group('QuickSupportBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<QuickSupportBloc>());
  //   });
  // });
}
