library nigori;

import 'dart:utf';
import 'package:/unittest/unittest.dart';
import 'dart:scalarlist';

part 'test.dart';

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
  static final int Bkdsa = 16;
  static final int Bkenc = 16;
  static final int Bkmac = 16;
  static final int Bkiv = 16;
  static final int Bkmaster = 16;
  static final Usersalt = new Uint8List(9);

  static void init() {
  Usersalt[0] = 117;
  Usersalt[1] = 115;
  Usersalt[2] = 101;
  Usersalt[3] = 114;
  Usersalt[4] = 32;
  Usersalt[5] = 115;
  Usersalt[6] = 97;
  Usersalt[7] = 108;
  Usersalt[8] = 116;
  }
}

/**
 * Implement || from the nigori spec
 * TODO(drt24) unit test
 * */
ByteArray byteconcat(String first, String second) {
  List<int> firstBytes = encodeUtf8(first);
  List<int> secondBytes = encodeUtf8(second);
  ByteArray ba = new Uint8List(4+firstBytes.length + 4 + secondBytes.length).asByteArray();

  int offset = ba.setInt32(0,firstBytes.length);
  firstBytes.forEach((byte) => offset = ba.setInt8(offset,byte));
  offset = ba.setInt32(offset,secondBytes.length);
  secondBytes.forEach((byte) => offset = ba.setInt8(offset,byte));
  return ba;
}