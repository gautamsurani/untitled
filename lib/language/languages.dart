import 'package:flutter/material.dart';

abstract class Languages {

  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get labelSelectCode;

  String get labelEnterCountryCode;

  String get labelSubmit;

  String get labelNoDataAvailable;

  String get labelIsEquivalent;

}