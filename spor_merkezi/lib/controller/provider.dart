import 'package:flutter/material.dart';

class Provider<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const Provider({
    super.key,
    required T model,
    required super.child,
  }) : super(notifier: model);

  // Generic of<T> metodu ile herhangi bir ViewModel'e erişim sağlar
  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<Provider<T>>();
    assert(provider != null, 'Provider<$T> bulunamadı! Provider ağacına eklenmiş mi?');
    return provider!.notifier!;
  }
}
