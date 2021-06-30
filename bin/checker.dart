import 'dart:io';

import 'package:checker/src/data/dependencies_data_source.dart';
import 'package:checker/src/data/package_license_data_source.dart';
import 'package:checker/src/data/packages_data_source.dart';
import 'package:path/path.dart';

void main(List<String> arguments) {
  final dependenciesDataSource = DependenciesDataSource.fromPubspec();
  final dependencies = dependenciesDataSource.retrieveDataFromSource();

  final packagesDataSource =
      PackagesDataSource.fromPubspecDependecies(dependencies);
  final packages = packagesDataSource.retrieveDataFromSource();

  for (final package in packages) {
    final licenseDataSource = PackageLicenseDataSource.fromPackage(package);
    final packageLicense = licenseDataSource.retrieveDataFromSource();
    print('${packageLicense.packageName} -> ${packageLicense.license}');
  }
}
