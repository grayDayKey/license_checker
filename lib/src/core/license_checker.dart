import 'dart:io';

import 'package:checker/src/core/license.dart';
import 'package:meta/meta.dart';

abstract class LicenseChecker {

  final String license;

  LicenseChecker(this.license);

  bool check() {
    for (var pattern in patterns) {
      if (pattern.hasMatch(license)) {
        return true;
      }
    }

    return false;
  }

  License get type;

  @protected
  List<RegExp> get patterns;
}

class MitLicenseChecker extends LicenseChecker {

  MitLicenseChecker(String license) : super(license);

  @override
  License get type => License.MIT;

  @protected
  @override
  List<RegExp> get patterns => [
    RegExp('ermission is hereby granted, free of charge, to any'),
    RegExp('\\bMIT\\b'),
  ];
}

class BsdLicenseChecker extends LicenseChecker {

  BsdLicenseChecker(String license) : super(license);

  @override
  License get type => License.BSD;

  @protected
  @override
  List<RegExp> get patterns => [
    RegExp('edistribution and use in source and binary forms, with or withou'),
  ];
}

class GplLicenseChecker extends LicenseChecker {

  GplLicenseChecker(String license) : super(license);

  @override
  License get type => License.GPL;

  @protected
  @override
  List<RegExp> get patterns => [
    RegExp('\\bGNU GENERAL PUBLIC LICENSE\s*Version ([^,]*)')
  ];
}

class ApacheLicenseChecker extends LicenseChecker {
  ApacheLicenseChecker(String license) : super(license);

  @override
  License get type => License.APACHE;

  @protected
  @override
  List<RegExp> get patterns => [
    RegExp('\\bApache License\\b')
  ];
}

class LicenseParser {
  static License parse(File licenseFile) {
    final license = licenseFile.readAsStringSync();

    for (var checker in [MitLicenseChecker(license), GplLicenseChecker(license), ApacheLicenseChecker(license), BsdLicenseChecker(license)]) {
      if (checker.check()) return checker.type;
    }

    return License.unknown;
  }
}

var MIT_LICENSE = 'ermission is hereby granted, free of charge, to any';
var BSD_LICENSE =
    'edistribution and use in source and binary forms, with or withou';
var BSD_SOURCE_CODE_LICENSE =
    'edistribution and use of this software in source and binary forms, with or withou';
var WTFPL_LICENSE = 'DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE';
var ISC_LICENSE = 'The ISC License';
var MIT = '\\bMIT\\b';
var BSD = '\\bBSD\\b';
var ISC = '\\bISC\\b';
var GPL = '\\bGNU GENERAL PUBLIC LICENSE\s*Version ([^,]*)';
var LGPL = '(?:LESSERz|LIBRARY) GENERAL PUBLIC LICENSE\s*Version ([^,]*)';
var APACHE = '\\bApache License\\b';
var WTFPL = '\\bWTFPL\\b';
// https://creativecommons.org/publicdomain/zero/1.0/
// var CC0_1_0 = /The\s+person\s+who\s+associated\s+a\s+work\s+with\s+this\s+deed\s+has\s+dedicated\s+the\s+work\s+to\s+the\s+public\s+domain\s+by\s+waiving\s+all\s+of\s+his\s+or\s+her\s+rights\s+to\s+the\s+work\s+worldwide\s+under\s+copyright\s+law,\s+including\s+all\s+related\s+and\s+neighboring\s+rights,\s+to\s+the\s+extent\s+allowed\s+by\s+law.\s+You\s+can\s+copy,\s+modify,\s+distribute\s+and\s+perform\s+the\s+work,\s+even\s+for\s+commercial\s+purposes,\s+all\s+without\s+asking\s+permission./i; // jshint ignore:line
// var PUBLIC_DOMAIN = /[Pp]ublic [Dd]omain/;
// var IS_URL = /(https?:\/\/[-a-zA-Z0-9\/.]*)/;
// var IS_FILE_REFERENCE = /SEE LICENSE IN (.*)/i;
