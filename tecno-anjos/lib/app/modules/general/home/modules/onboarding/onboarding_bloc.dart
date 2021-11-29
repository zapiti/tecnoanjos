import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/rxdart.dart';

class OnboardingBloc extends Disposable {
  //dispose will be called automatically by closing its streams

  BehaviorSubject<bool> enableButton = BehaviorSubject<bool>.seeded(true);
  BehaviorSubject<bool> hideButton = BehaviorSubject<bool>.seeded(false);

  @override
  void dispose() {
    enableButton.drain();
    hideButton.drain();
  }
}
