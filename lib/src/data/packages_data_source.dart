import 'dart:convert';
import 'dart:io';

import 'package:checker/src/data/data_source.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pubspec_parse;

import 'data_source_exception.dart';

const _kPackageConfigPath = '.dart_tool/package_config.json';
const _kPackageFilePrefix = 'file://';

class PackagesDataSource
    extends DataSource<List<Directory>, Map<String, pubspec_parse.Dependency>> {
  PackagesDataSource._(
      Map<String, pubspec_parse.Dependency> source, this._packageConfigFile)
      : super(source);

  final File _packageConfigFile;

  factory PackagesDataSource.fromPubspecDependecies(
      Map<String, pubspec_parse.Dependency> dependencies,
      [File packageConfigFile]) {
    packageConfigFile ??= File(_kPackageConfigPath);

    return PackagesDataSource._(dependencies, packageConfigFile);
  }

  @override
  List<Directory> getData() {
    if (!_packageConfigFile.existsSync()) {
      throw DataSourceException('could not find package config file');
    }

    final Map<String, dynamic> json =
        jsonDecode(_packageConfigFile.readAsStringSync());
    final packages = <Directory>[];

    if (!json.containsKey('packages')) {
      throw DataSourceException(
          'there is no packages in ${_packageConfigFile.path}');
    }

    for (final package in json['packages']) {
      final packageName = package['name'];

      if (source.keys.contains(packageName)) {
        final packageUri = package['rootUri'];
        final packageDirectory = _retrivePackage(packageUri);

        if (packageDirectory.existsSync()) {
          packages.add(packageDirectory);
        }
      }
    }

    return packages;
  }

  Directory _retrivePackage(String uri) {
    final norimilizedUri = _normilizePackageUri(uri);
    return Directory(norimilizedUri);
  }

  String _normilizePackageUri(String uri) {
    return uri.replaceFirst(RegExp(_kPackageFilePrefix), '');
  }
}
