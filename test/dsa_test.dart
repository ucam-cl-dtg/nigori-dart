import 'package:unittest/unittest.dart';
import 'package:nigori/nigori.dart';
import 'package:nigori/dsa.dart';
import 'package:nigori/test.dart';

void main() {
  test('dsa sign runs', () => Dsa.sign(toBytes("message"),toBytes("foo")));
  
}