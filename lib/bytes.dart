
part of nigori;


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
  List<int> byteList = new List.fixedLength(length);
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
ByteArray bigIntegerToByteArray(BigInteger integer){
  return toByteArray(integer.toByteArray());
}

int byteArrayToInt(ByteArray array){
  return int.parse("0x${CryptoUtils.bytesToHex(byteArrayToByteList(array))}");
}

int byteListToInt(List<int> byteList) {
  return int.parse("0x${CryptoUtils.bytesToHex(byteList)}");
}

ByteArray intToByteArray(int integer){
  ByteArray toflip = new Uint32List(1).asByteArray();
  ByteArray target = new Uint8List(4).asByteArray();
  toflip.setInt32(0, integer);
  int offset = 0;
  offset = target.setInt8(offset,toflip.getInt8(3));//Reverse byte order
  offset = target.setInt8(offset,toflip.getInt8(2));
  offset = target.setInt8(offset,toflip.getInt8(1));
  offset = target.setInt8(offset,toflip.getInt8(0));
  return target;
}

List<int> _convertTypesToListInt(dynamic item){
  List<int> itemBytes;
  if (item is String)
    itemBytes = encodeUtf8(item);
  else if (item is List<int>)
    itemBytes = item;
  else if (item is BigInteger)
    itemBytes = item.toByteArray();
  else
    throw new ArgumentError("Invalid type of item '${item}'");
  return itemBytes;
}
/**
 * Implement || from the nigori spec
 * items can be Strings or List<int>s (of bytes) or BigIntegers, types can be mixed
 * TODO(drt24) unit test
 * */
ByteArray byteconcat(List<dynamic> items) {
  const intLength = 4;
  List<List<int>> byteArrays = new List.fixedLength(items.length);
  int index = 0;
  items.forEach((item){ byteArrays[index] = _convertTypesToListInt(item); ++index;});
  int length = 0;
  byteArrays.forEach((array) => length += intLength + array.length); 

  ByteArray ba = new Uint8List(length).asByteArray();

  int offset = 0;
  byteArrays.forEach((array) {
    offset = _byteconcatInteger(offset,array.length,ba);
    array.forEach((byte) => offset = ba.setInt8(offset,byte));
    });
  return ba;
}
/**
 * Write an int of the length into the target array
 */
int _byteconcatInteger(int offset, int integer, ByteArray target){
  ByteArray length = new Uint32List(1).asByteArray();
  length.setInt32(0, integer);
  offset = target.setInt8(offset,length.getInt8(3));//Reverse byte order
  offset = target.setInt8(offset,length.getInt8(2));
  offset = target.setInt8(offset,length.getInt8(1));
  offset = target.setInt8(offset,length.getInt8(0));
  return offset;
}