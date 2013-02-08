library nigori;

import 'dart:utf';
import 'dart:scalarlist';
import 'dart:crypto';
import 'dart:json';
import 'dart:math';
import 'package:json_object/json_object.dart';
import 'package:bignum/bignum.dart';

part 'bytes.dart';
part 'messages.dart';

/**
 * Refer to the Constants section of the RFC for the meaning of these constants
 **/
class NigoriConstants {
  static final int Nsalt = 1000;
  static final int Nuser = 1001;
  static final int Nenc = 1002;
  static final int Nmac = 1003;
  static final int Niv = 1004;
  static final int Nmaster = 1005;
  static final int Bsuser = 16;
  static final int Bkdsa = 32;
  static final int Bkenc = 16;
  static final int Bkmac = 16;
  static final int Bkiv = 16;
  static final int Bkmaster = 16;
  static final ByteArray Usersalt = toByteArray([117,115,101,114,32,115,97,108,116]);
}

class NigoriNonce {
  static final _randomGen = new Random();
  int _timestamp;
  int _random;
  /**
   * time since epoch in seconds
   */
  int get timestamp => _timestamp;
  int get random => _random;
  NigoriNonce() {
    _timestamp = new DateTime.now().millisecondsSinceEpoch~/1000;
    _random = _randomGen.nextInt(((1<<32) - 1));
  }
  ByteArray toByteArray() {
    ByteArray ba = new Uint8List(8).asByteArray();
    int offset = 0;
    offset = _byteconcatInteger(offset,_random,ba);
    offset = _byteconcatInteger(offset,_timestamp,ba);
  }
}