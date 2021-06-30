import 'dart:io';

import 'package:checker/src/parser/package_license_parser.dart';
import 'package:path/path.dart' as path;

enum License {
  APACHE,
  BSD,
  GPL,
  ICS,
  MIT,
  LGPL,
  WTFPL,
  unknown,
  unlicensed,
}

extension LicenseFactory on License {
  static License fromLicenseFile(File licenseFile) =>
      LicenseParser.parse(licenseFile);
}

class PackageLicense {
  final Directory package;
  final License license;

  PackageLicense(this.package, this.license);

  String get packageName => path.basename(package.path);
}
