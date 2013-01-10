library dsa;

import 'dart:scalarlist';
import 'dart:math';
import 'dart:crypto';
import 'package:nigori/nigori.dart';
import 'package:bignum/bignum.dart';

class Dsa {
  static final BigInteger DSA_P = new BigInteger( 0x90066455B5CFC38F9CAA4A48B4281F292C260FEEF01FD61037E56258A7795A1C7AD46076982CE6BB956936C6AB4DCFE05E6784586940CA544B9B2140E1EB523F009D20A7E7880E4E5BFA690F1B9004A27811CD9904AF70420EEFD6EA11EF7DA129F58835FF56B89FAA637BC9AC2EFAAB903402229F491D8D3485261CD068699B6BA58A1DDBBEF6DB51E8FE34E8A78E542D7BA351C21EA8D8F1D29F5D5D15939487E27F4416B0CA632C59EFD1B1EB66511A5A0FBF615B766C5862D0BD8A3FE7A0E0DA0FB2FE1FCB19E8F9996A8EA0FCCDE538175238FC8B0EE6F29AF7F642773EBE8CD5402415A01451A840476B2FCEB0E388D30D4B376C37FE401C2A2C2F941DAD179C540C1C8CE030D460C4D983BE9AB0B20F69144C1AE13F9383EA1C08504FB0BF321503EFE43488310DD8DC77EC5B8349B8BFE97C2C560EA878DE87C11E3D597F1FEA742D73EEC7F37BE43949EF1A0D15C3F3E3FC0A8335617055AC91328EC22B50FC15B941D3D1624CD88BC25F3E941FDDC6200689581BFEC416B4B2CB73);
  static final BigInteger DSA_Q = new BigInteger( 0xCFA0478A54717B08CE64805B76E5B14249A77A4838469DF7F7DC987EFCCFB11D);
  static final BigInteger DSA_G = new BigInteger( 0x5E5CBA992E0A680D885EB903AEA78E4A45A469103D448EDE3B7ACCC54D521E37F84A4BDD5B06B0970CC2D2BBB715F7B82846F9A0C393914C792E6A923E2117AB805276A975AADB5261D91673EA9AAFFEECBFA6183DFCB5D3B7332AA19275AFA1F8EC0B60FB6F66CC23AE4870791D5982AAD1AA9485FD8F4A60126FEB2CF05DB8A7F0F09B3397F3937F2E90B9E5B9C9B6EFEF642BC48351C46FB171B9BFA9EF17A961CE96C7E7A7CC3D3D03DFAD1078BA21DA425198F07D2481622BCE45969D9C4D6063D72AB7A0F08B2F49A7CC6AF335E08C4720E31476B67299E231F8BD90B39AC3AE3BE0C6B6CACEF8289A2E2873D58E51E029CAFBD55E6841489AB66B5B4B9BA6E2F784660896AFF387D92844CCB8B69475496DE19DA2E58259B090489AC8E62363CDF82CFD8EF2A427ABCD65750B506F56DDE3B988567A88126B914D7828E2B63A6D7ED0747EC59E0E0A23CE7D8A74C1D2C2A7AFB6A29799620F00E11C33787F7DED3B30E1A22D09F1FBDA1ABBBFBF25CAE05A13F812E34563F99410E73B);
  static final DsaParameters defaultParameters = new DsaParameters(DSA_P,DSA_Q,DSA_G);

  static DsaSignature sign(ByteArray message, ByteArray privateKey){
    BigInteger k = _randomBitsLessThan(256,DSA_Q);
    BigInteger km1 = _inverse(k,DSA_Q);
    BigInteger r = DSA_G.modPow(k, DSA_P).mod(DSA_Q);
    
    BigInteger s = (km1 * (_hash(message) + new BigInteger(byteArrayToInt(privateKey)) * r)) % DSA_Q;
    return new DsaSignature(r,s);
  }

  static void verify(ByteArray message, DsaSignature signature, ByteArray publicKey){
    if (!(BigInteger.ZERO < signature.r && signature.r < DSA_Q)){
      throw new InvalidSignatureException("Invalid r: !0 < r< q");
    }
    if (!(BigInteger.ZERO < signature.s && signature.s < DSA_Q)){
      throw new InvalidSignatureException("Invalid s: !0 < s< q");
    }
    BigInteger w = _inverse(signature.s,DSA_Q);
    BigInteger z = _hash(message);
    int u1 = ((z * w) % DSA_Q).intValue();
    int u2 = ((signature.r * w) % DSA_Q).intValue();
    BigInteger v = ((DSA_G.pow(u1)*new BigInteger(byteArrayToInt(publicKey)).pow(u2))%DSA_P)%DSA_Q;
    if (v != signature.r){
      throw new InvalidSignatureException("v != r");
    }
  }

  static BigInteger _hash(ByteArray message){
    SHA256 hashFunction = new SHA256();
    hashFunction.update(byteArrayToByteList(message));
    List<int> hash = hashFunction.digest();
    return new BigInteger(byteListToInt(hash));
  }
  /**
   * Generate an integer which is less than [lessThan] and [numBits] in size.
   * [numBits] must be a multiple of 32.
   */
  static BigInteger _randomBitsLessThan(int numBits, BigInteger lessThan){
    if (numBits %32 != 0){
      throw new ArgumentError("numBits must be multiple of 32");
    }
    //FIXME(drt24) This is a security flaw, Dart's random number generator is not cryptographically random, it might be good enough but I don't trust it.
    Random random = new Random();
    BigInteger value;
    do {
      value = new BigInteger(random.nextInt(((1<<32) - 1)));
      for (int i =1; i < numBits/32; ++i) {
        value <<=32;
        value |= new BigInteger(random.nextInt(((1<<32) - 1)));
      }
    } while (value >= lessThan);
    return value;
  }
  /**
   * from FIPS 186-3 Appendix C.1
   */
  static BigInteger _inverse(BigInteger z, BigInteger a){
    if (z < BigInteger.ZERO || a < BigInteger.ZERO){
      throw new ArgumentError("z or a < 0. z: ${z}, a: ${a}");
    }
    if (z >= a){
      throw new ArgumentError("z must be < a. z: ${z}, a: ${a}");
    }
    BigInteger i = a, j=z,y2=BigInteger.ZERO,y1=BigInteger.ONE;
    while (j > BigInteger.ZERO){
      BigInteger quotient = i/j;
      BigInteger remainder = i - (j*quotient);
      BigInteger y = y2-(y1*quotient);
      i=j;j=remainder;y2-y1;y1=y;
    }
    if (i != BigInteger.ONE){
      throw new DsaException("Error while computing inverse, i!=1");
    }
    return y2%a;
  }
}
class InvalidSignatureException implements Exception {
  InvalidSignatureException(String message){
    super(message);
  }
}
class DsaException implements Exception {
  DsaException(String message){
    super(message);
  }
}

class DsaParameters {
  final BigInteger g;
  final BigInteger q;
  final BigInteger p;
  DsaParameters(this.p,this.q,this.g);
}
class DsaSignature {
  final BigInteger r;
  final BigInteger s;
  DsaSignature(this.r,this.s);
}