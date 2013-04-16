library test;

import 'package:unittest/unittest.dart';
import 'dart:typeddata';
import 'package:nigori/nigori.dart';

class _ByteArrayMatcher extends BaseMatcher {
  final ByteData _expected;
  _ByteArrayMatcher(this._expected);
  bool matches(ByteData item, MatchState matchState){
    int expectedLength = _expected.lengthInBytes;
    if (expectedLength != item.lengthInBytes){
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
    return mismatchDescription.add(byteArrayToString(_expected));
  }
  Description describeMismatch(ByteData item, Description mismatchDescription, MatchState matchState, bool verbose) =>
      mismatchDescription.add('was ').add(byteArrayToString(item));
}

Matcher byteArrayEquals(ByteData array) => new _ByteArrayMatcher(array);