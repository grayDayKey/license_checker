import 'dart:io';

import 'package:license_checker/license_checker.dart';
import 'package:license_checker/src/data/data_source.dart';
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

    final files = source.listSync(recursive: false).whereType<File>();

    for (final file in files) {
      for (final licensePattern in _kLicensePatterns) {
        final fileName = path.basename(file.path).toUpperCase();

        if (RegExp(licensePattern).hasMatch(fileName)) {
          return PackageLicense(
            source,
            LicenseChecker.getLicenseType(
              file.readAsStringSync()
            )
          );
        }
      }
    }

    return PackageLicense(source, License.unlicensed);
  }
}
