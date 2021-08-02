import 'dart:io';

import 'package:license_checker/license_checker.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {

  final assets = Directory(path.join('test', 'assets'))
    .listSync()
    .whereType<File>();

  final checkLicenseByType = (String pattern, License licenseType) {
    final licenseFiles = assets
      .where((element) =>
        RegExp(pattern).hasMatch(path.basename(element.path)));

    for (var licenseFile in licenseFiles) {
      final checker = LicenseChecker.forType(
        licenseType, licenseFile.readAsStringSync());
      expect(checker.check(), isTrue);
    }
  };
  
  test('MIT license should be true', () => 
    checkLicenseByType('mit', License.MIT));
  test('Apache license should be true', () => 
    checkLicenseByType('apache', License.APACHE));
  test('BSD license should be true', () => 
    checkLicenseByType('bsd', License.BSD));
  test('GPL license should be true', () => 
    checkLicenseByType(r'^gpl', License.GPL));
  test('LGLP license should be true', () => 
    checkLicenseByType('lgpl', License.LGPL));
  test('ICS license should be true', () => 
    checkLicenseByType('ics', License.ICS));
  test('WTFPL license should be true', () => 
    checkLicenseByType('wtfpl', License.WTFPL));
}
