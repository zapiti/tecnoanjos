import 'package:flutter_modular/flutter_modular.dart';
import 'onboarding_page.dart';

class OnboardingModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute,
            child: (_, args) => OnboardPage()),
      ];

  static Inject get to => Inject<OnboardingModule>.of();
}
