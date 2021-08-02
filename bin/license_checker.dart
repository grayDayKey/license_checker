import 'package:license_checker/license_checker.dart';

void main(List<String> arguments) {
  final dependenciesDataSource = DependenciesDataSource.fromPubspec();
  final dependencies = dependenciesDataSource.getData();

  final packagesDataSource =
      PackagesDataSource.fromPubspecDependecies(dependencies);
  final packages = packagesDataSource.getData();

  for (final package in packages) {
    final licenseDataSource = PackageLicenseDataSource.fromPackage(package);
    final packageLicense = licenseDataSource.getData();
    print('${packageLicense.packageName} -> ${packageLicense.license}');
  }
}
