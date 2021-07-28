import 'dart:io';

import 'package:path/path.dart' as path;

/// Is a type of license for computer software and other products that allows the source code,
/// blueprint or design to be used modified and/or shared under defined terms and conditions.
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

class PackageLicense {
  final Directory package;
  final License license;

  PackageLicense(this.package, this.license);

  String get packageName => path.basename(package.path);
}
