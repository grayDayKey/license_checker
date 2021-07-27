import 'dart:io';

import 'package:checker/src/core/license.dart';
import 'package:checker/src/core/license_checker.dart';
import 'package:checker/src/data/data_source.dart';
import 'package:path/path.dart' as path;

const List<String> _kLicensePatterns = [
  '\^LICENSE\$',
  '\^LICENSE\-\w\+\$', // e.g. LICENSE-MIT
  '\^LICENCE\$',
  '\^LICENCE\-\w\+\$', // e.g. LICENCE-MIT
  '\^COPYING\$',
  '\^README\$',
];

class PackageLicenseDataSource extends DataSource<PackageLicense, Directory> {
  PackageLicenseDataSource._(Directory package) : super(package);

  factory PackageLicenseDataSource.fromPackage(Directory package) {
    return PackageLicenseDataSource._(package);
  }

  @override
  PackageLicense getData() {
    File licenseFile;
    LicenseChecker checker;

    final files = source.listSync(recursive: false).whereType<File>();

    for (final file in files) {
      for (final licensePattern in _kLicensePatterns) {
        final fileName = path.basename(file.path).toUpperCase();

        if (RegExp(licensePattern).hasMatch(fileName)) {
          return PackageLicense(source, LicenseFactory.fromLicenseFile(file));
        }
      }
    }

    return PackageLicense(source, License.unlicensed);
  }
}
