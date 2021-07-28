import 'package:checker/src/core/license.dart';
import 'package:meta/meta.dart';

/// Checks if the license is one of [supportedLicenses]
/// 
/// * [license] is a type of license for computer software and other products that allows the source code,
/// blueprint or design to be used modified and/or shared under defined terms and conditions.
abstract class LicenseChecker {

  LicenseChecker(this.license);
  
  /// Creates an instance of [LicenseChecker] based on [type]
  ///
  /// * [type] one of [supportedLicenses]
  /// * [license] is a type of license for computer software and other products that allows the source code,
  /// blueprint or design to be used modified and/or shared under defined terms and conditions.
  factory LicenseChecker.forType(License type, String license) {
    switch (type) {
      case License.MIT:
        return _MitLicenseChecker(license);
      case License.APACHE:
        return _ApacheLicenseChecker(license);
      case License.BSD:
        return _BsdLicenseChecker(license);
      case License.GPL:
        return _GplLicenseChecker(license);
      case License.ICS:
        return _IcsLicenseChecker(license);
      case License.LGPL:
        return _LgplLicenseChecker(license);
      case License.WTFPL:
        return _WtfplLicenseChecker(license);
      default:
        throw Exception('Unsopported license type: $type');
    }
  }

  /// Checks if [license] is [String], if not returns [License.unlicensed],
  /// then checks if [license] is one of [supportedLicenses], if not return [License.unknown]
  /// 
  /// * [license] is a type of license for computer software and other products that allows the source code,
  /// blueprint or design to be used modified and/or shared under defined terms and conditions.
  /// 
  /// Returns [License]
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

  /// List of supported [License]
  static const List<License> supportedLicenses = [
    License.MIT,
    License.BSD,
    License.GPL,
    License.ICS,
    License.LGPL,
    License.WTFPL,
  ];
}

class _MitLicenseChecker extends LicenseChecker {

  _MitLicenseChecker(String license) : super(license);

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

class _BsdLicenseChecker extends LicenseChecker {

  _BsdLicenseChecker(String license) : super(license);

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

class _GplLicenseChecker extends LicenseChecker {

  _GplLicenseChecker(String license) : super(license);

  @override
  License get type => License.GPL;

  @override
  List<RegExp> get patterns => [
    RegExp(r'\bGNU GENERAL PUBLIC LICENSE\b', caseSensitive: false)
  ];
}

class _ApacheLicenseChecker extends LicenseChecker {
  _ApacheLicenseChecker(String license) : super(license);

  @override
  License get type => License.APACHE;

  @override
  List<RegExp> get patterns => [
    RegExp('\\bApache License\\b', caseSensitive: false)
  ];
}

class _LgplLicenseChecker extends LicenseChecker {
  _LgplLicenseChecker(String license) : super(license);
  
  @override
  List<RegExp> get patterns => [
    RegExp(
      r'(?:LESSER|LIBRARY) GENERAL PUBLIC LICENSE\s*Version ([^,]*)',
      caseSensitive: false)
  ];

  @override
  License get type => License.LGPL;
}

class _IcsLicenseChecker extends LicenseChecker {
  _IcsLicenseChecker(String license) : super(license);

  @override
  List<RegExp> get patterns => [
    RegExp('\\bISC\\b', caseSensitive: false),
    RegExp('The ISC License', caseSensitive: false),
  ];

  @override
  License get type => License.ICS;
}

class _WtfplLicenseChecker extends LicenseChecker {
  _WtfplLicenseChecker(String license) : super(license);

  @override
  List<RegExp> get patterns => [
    RegExp('\\bWTFPL\\b', caseSensitive: false),
    RegExp('DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE', caseSensitive: false),
  ];

  @override
  License get type => License.WTFPL;
}
