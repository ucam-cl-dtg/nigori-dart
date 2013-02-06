import 'package:unittest/unittest.dart';
import 'package:nigori/nigori.dart';
import 'dart:scalarlist';
import 'package:nigori/test.dart';
import 'dart:utf';

void main() {
  test('byteconcat runs', () => byteconcat("first", "second"));
  test('byteconcat type', () => expect(byteconcat("first", "second"),new isInstanceOf<ByteArray>()));
  ByteArray firstSecond = toByteArray([/*first is 5 bytes*/ 0,0,0,5,
                                       /*first*/ 102, 105, 114, 115, 116,
                                       /*second is 6 bytes*/ 0,0,0,6,
                                       /*second*/ 115, 101, 99, 111, 110, 100]);
  test('byteconcat value string', () => expect(byteconcat("first", "second"),byteArrayEquals(firstSecond)));
  test('byteconcat value List<int>', () => expect(byteconcat(encodeUtf8("first"), encodeUtf8("second")),byteArrayEquals(firstSecond)));
  test('byteArrayToString', () => expect(byteArrayToString(toByteArray([1, 2, 3, 4, 5])),equals("[1, 2, 3, 4, 5]")));
  test('toFromBytes', () => expect(fromBytes(toBytes("string")),equals("string")));
}
