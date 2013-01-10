library nigori;

import 'dart:utf';
import 'dart:scalarlist';
import 'dart:crypto';

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
  static final ByteArray Usersalt = toByteArray([117,115,101,114,32,115,97,108,116]);
}

ByteArray toByteArray(List<int> ints){
  Uint8List list = new Uint8List(ints.length);
  int i = 0;
  ints.forEach((byte) { list[i] = byte; ++i;});
  return list.asByteArray();
}

ByteArray toBytes(String string){
  List<int> byteList = encodeUtf8(string);
  ByteArray ba = new Uint8List(byteList.length).asByteArray();
  int offset = 0;
  byteList.forEach((byte) => offset = ba.setInt8(offset, byte));
  return ba;
}

String fromBytes(ByteArray array){
  List<int> byteList = byteArrayToByteList(array);
  return decodeUtf8(byteList);
}

List<int> byteArrayToByteList(ByteArray array){
  int length = array.lengthInBytes();
  List<int> byteList = new List(length);
  for (int i = 0; i < length; ++i){
    byteList[i] = array.getInt8(i);
  }
  return byteList;
}

String byteArrayToString(ByteArray array){
  int length = array.lengthInBytes();
  String answer = "[";
  for (int i = 0; i < length; ++i){
    answer = "$answer${i>0 ? ', ':''}${array.getInt8(i)}";
  }
  answer = "$answer]";
  return answer;
}

int byteArrayToInt(ByteArray array){
  return int.parse("0x${CryptoUtils.bytesToHex(byteArrayToByteList(array))}");
}

int byteListToInt(List<int> byteList) {
  return int.parse("0x${CryptoUtils.bytesToHex(byteList)}");
}

/**
 * Implement || from the nigori spec
 * TODO(drt24) unit test
 * */
ByteArray byteconcat(String first, String second) {
  List<int> firstBytes = encodeUtf8(first);
  List<int> secondBytes = encodeUtf8(second);
  ByteArray ba = new Uint8List(4+firstBytes.length + 4 + secondBytes.length).asByteArray();

  int offset = 0;
  offset = _byteconcatLength(offset,firstBytes.length,ba);
  firstBytes.forEach((byte) => offset = ba.setInt8(offset,byte));
  offset = _byteconcatLength(offset,secondBytes.length,ba);
  secondBytes.forEach((byte) => offset = ba.setInt8(offset,byte));
  return ba;
}
/**
 * Write an int of the length into the target array
 */
int _byteconcatLength(int offset, int bytelength, ByteArray target){
  ByteArray length = new Uint32List(1).asByteArray();
  length.setInt32(0, bytelength);
  offset = target.setInt8(offset,length.getInt8(3));//Reverse byte order
  offset = target.setInt8(offset,length.getInt8(2));
  offset = target.setInt8(offset,length.getInt8(1));
  offset = target.setInt8(offset,length.getInt8(0));
  return offset;
}