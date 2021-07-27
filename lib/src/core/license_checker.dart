import 'package:checker/src/core/license.dart';
import 'package:meta/meta.dart';

abstract class LicenseChecker {

  LicenseChecker(this.license);

  factory LicenseChecker.forType(License type, String license) {
    switch (type) {
      case License.MIT:
        return MitLicenseChecker(license);
      case License.APACHE:
        return ApacheLicenseChecker(license);
      case License.BSD:
        return BsdLicenseChecker(license);
      case License.GPL:
        return GplLicenseChecker(license);
      case License.ICS:
        return IcsLicenseChecker(license);
      case License.LGPL:
        return LgplLicenseChecker(license);
      case License.WTFPL:
        return WtfplLicenseChecker(license);
      default:
        throw Exception('Unsopported license type: $type');
    }
  }

  static License getLicenseType(String license) {
    if (license is! String) {
      License.unlicensed;
    }

    for (var licenseType in LicenseChecker.supportedLicenses) {
      final checker = LicenseChecker.forType(licenseType, license);
      if (checker.check()) {
        return checker.type;
      }
    }

    return License.unknown;
  }

  final String license;

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

  static const List<License> supportedLicenses = [
    License.MIT,
    License.BSD,
    License.GPL,
    License.ICS,
    License.LGPL,
    License.WTFPL,
  ];
}

class MitLicenseChecker extends LicenseChecker {

  MitLicenseChecker(String license) : super(license);

  @override
  License get type => License.MIT;

  @override
  List<RegExp> get patterns => [
    RegExp(
      'ermission is hereby granted, free of charge, to any',
      caseSensitive: false
    ),
    RegExp(
      '\\bMIT\\b',
      caseSensitive: false
    ),
  ];
}

class BsdLicenseChecker extends LicenseChecker {

  BsdLicenseChecker(String license) : super(license);

  @override
  License get type => License.BSD;

  @override
  List<RegExp> get patterns => [
    RegExp(
      'edistribution and use in source and binary forms, with or withou',
      caseSensitive: false
    ),
  ];
}

class GplLicenseChecker extends LicenseChecker {

  GplLicenseChecker(String license) : super(license);

  @override
  License get type => License.GPL;

  @override
  List<RegExp> get patterns => [
    RegExp(r'\bGNU GENERAL PUBLIC LICENSE\b', caseSensitive: false)
  ];
}

class ApacheLicenseChecker extends LicenseChecker {
  ApacheLicenseChecker(String license) : super(license);

  @override
  License get type => License.APACHE;

  @override
  List<RegExp> get patterns => [
    RegExp('\\bApache License\\b', caseSensitive: false)
  ];
}

class LgplLicenseChecker extends LicenseChecker {
  LgplLicenseChecker(String license) : super(license);
  
  @override
  List<RegExp> get patterns => [
    RegExp(
      r'(?:LESSER|LIBRARY) GENERAL PUBLIC LICENSE\s*Version ([^,]*)',
      caseSensitive: false)
  ];

  @override
  License get type => License.LGPL;
}

class IcsLicenseChecker extends LicenseChecker {
  IcsLicenseChecker(String license) : super(license);

  @override
  List<RegExp> get patterns => [
    RegExp('\\bISC\\b', caseSensitive: false),
    RegExp('The ISC License', caseSensitive: false),
  ];

  @override
  License get type => License.ICS;
}

class WtfplLicenseChecker extends LicenseChecker {
  WtfplLicenseChecker(String license) : super(license);

  @override
  List<RegExp> get patterns => [
    RegExp('\\bWTFPL\\b', caseSensitive: false),
    RegExp('DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE', caseSensitive: false),
  ];

  @override
  License get type => License.WTFPL;
}
