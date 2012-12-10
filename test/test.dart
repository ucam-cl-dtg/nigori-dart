import 'package:unittest/unittest.dart';
import 'package:nigori/nigori.dart';
import 'dart:scalarlist';

class _ByteArrayMatcher extends BaseMatcher {
  final ByteArray _expected;
  _ByteArrayMatcher(this._expected);
  bool matches(ByteArray item, MatchState matchState){
    int expectedLength = _expected.lengthInBytes();
    if (expectedLength != item.lengthInBytes()){
      return false;
    }
    for (int i = 0; i < expectedLength; ++i){
      if (_expected.getInt8(i) != item.getInt8(i)){
        return false;
      }// TODO(drt24) use matchState to pass information to describe
    }
    return true;
  }
  Description describe (Description mismatchDescription){
    //TODO(drt24) description
    return mismatchDescription;
  }
}

Matcher byteArrayEquals(ByteArray array) => new _ByteArrayMatcher(array);

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
