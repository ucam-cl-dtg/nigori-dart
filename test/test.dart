import 'package:unittest/unittest.dart';
import 'package:nigori/nigori.dart';
import 'dart:scalarlist';


void main() {
  test('byteconcat runs', () => byteconcat("first", "second"));
  test('byteconcat type', () => expect(byteconcat("first", "second"),new isInstanceOf<ByteArray>()));
}
