import 'package:flutter/material.dart';

class HandleChange {
  var controllers = Map<String, TextEditingController>();
  var controllersDisableds = Map<String, bool>();

  TextEditingController add(String identifier) {
    return controllers.putIfAbsent(identifier, () => TextEditingController(text: ''));
  }

  addDisabled(String identifier) {
    return controllersDisableds.putIfAbsent(identifier, () => true);
  }

  disableAll(bool value) {
    for (var item in controllersDisableds.keys) {
      if (item == null)
        continue;

      controllersDisableds[item] = value;
    }
  }

  setValue(Map<String, dynamic> object) {
    for (var item in object.keys) {
      if (item == null)
        continue;

      controllers[item] = TextEditingController(text: object[item].toString());
    }
  }

  Map<String, TextEditingController> get() {
    return controllers;
  }
}