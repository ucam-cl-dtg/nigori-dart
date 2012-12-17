import 'package:unittest/unittest.dart';
import 'package:nigori/nigori.dart';
import 'dart:scalarlist';
import 'package:nigori/test.dart';

void main() {
  test('byteconcat runs', () => byteconcat("first", "second"));
  test('byteconcat type', () => expect(byteconcat("first", "second"),new isInstanceOf<ByteArray>()));
  Uint8List firstSecond = new Uint8List(19);
  //first is 5 bytes
  firstSecond[0] = 0;
  firstSecond[1] = 0;
  firstSecond[2] = 0;
  firstSecond[3] = 5;
  // first = 102 105 114 115 116
  firstSecond[4] = 102;
  firstSecond[5] = 105;
  firstSecond[6] = 114;
  firstSecond[7] = 115;
  firstSecond[8] = 116;
  //second is 6 bytes
  firstSecond[9] = 0;
  firstSecond[10] = 0;
  firstSecond[11] = 0;
  firstSecond[12] = 6;
  // second = 115 101 99 111 110 100
  firstSecond[13] = 115;
  firstSecond[14] = 101;
  firstSecond[15] = 99;
  firstSecond[16] = 111;
  firstSecond[17] = 110;
  firstSecond[18] = 100;
  test('byteconcat value', () => expect(byteconcat("first", "second"),byteArrayEquals(firstSecond.asByteArray())));
}
