import 'dart:io';

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

class PackageLicense {
  final Directory package;
  final License license;

  PackageLicense(this.package, this.license);

  String get packageName => path.basename(package.path);
}
