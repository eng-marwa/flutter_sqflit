import 'dart:async';

import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showBanner(String message) {
    var state = ScaffoldMessenger.of(this);
    MaterialBanner materialBanner = MaterialBanner(
      content: Text(message),
      actions: [Text('')],
    );
    state.showMaterialBanner(materialBanner);
    Timer(const Duration(seconds: 2), () => state.hideCurrentMaterialBanner());
  }
}
