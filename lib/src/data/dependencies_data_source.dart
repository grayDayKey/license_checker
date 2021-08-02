import 'dart:io';

import 'package:license_checker/src/data/data_source.dart';
import 'package:license_checker/src/data/data_source_exception.dart';
import 'package:pubspec_parse/pubspec_parse.dart' as pubspec_parser;

const _kPubspecPath = 'pubspec.yaml';

class DependenciesDataSource
    extends DataSource<Map<String, pubspec_parser.Dependency>, File> {
  DependenciesDataSource._(File source) : super(source);

  factory DependenciesDataSource.fromPubspec([File pubspecFile]) {
    pubspecFile ??= File(_kPubspecPath);
    return DependenciesDataSource._(pubspecFile);
  }

  @override
  Map<String, pubspec_parser.Dependency> getData() {
    if (!source.existsSync()) {
      throw DataSourceException('could not find pubspec file');
    }

    final pubspec = pubspec_parser.Pubspec.parse(source.readAsStringSync());

    return pubspec.dependencies;
  }
}
