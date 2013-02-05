library dsa;

import 'dart:scalarlist';
import 'dart:math';
import 'dart:crypto';
import 'package:nigori/nigori.dart';
import 'package:bignum/bignum.dart';

class Dsa {
  static final DsaParameters parameters3072 = new DsaParameters(
      new BigInteger( 0x90066455B5CFC38F9CAA4A48B4281F292C260FEEF01FD61037E56258A7795A1C7AD46076982CE6BB956936C6AB4DCFE05E6784586940CA544B9B2140E1EB523F009D20A7E7880E4E5BFA690F1B9004A27811CD9904AF70420EEFD6EA11EF7DA129F58835FF56B89FAA637BC9AC2EFAAB903402229F491D8D3485261CD068699B6BA58A1DDBBEF6DB51E8FE34E8A78E542D7BA351C21EA8D8F1D29F5D5D15939487E27F4416B0CA632C59EFD1B1EB66511A5A0FBF615B766C5862D0BD8A3FE7A0E0DA0FB2FE1FCB19E8F9996A8EA0FCCDE538175238FC8B0EE6F29AF7F642773EBE8CD5402415A01451A840476B2FCEB0E388D30D4B376C37FE401C2A2C2F941DAD179C540C1C8CE030D460C4D983BE9AB0B20F69144C1AE13F9383EA1C08504FB0BF321503EFE43488310DD8DC77EC5B8349B8BFE97C2C560EA878DE87C11E3D597F1FEA742D73EEC7F37BE43949EF1A0D15C3F3E3FC0A8335617055AC91328EC22B50FC15B941D3D1624CD88BC25F3E941FDDC6200689581BFEC416B4B2CB73),
      new BigInteger( 0xCFA0478A54717B08CE64805B76E5B14249A77A4838469DF7F7DC987EFCCFB11D),
      new BigInteger( 0x5E5CBA992E0A680D885EB903AEA78E4A45A469103D448EDE3B7ACCC54D521E37F84A4BDD5B06B0970CC2D2BBB715F7B82846F9A0C393914C792E6A923E2117AB805276A975AADB5261D91673EA9AAFFEECBFA6183DFCB5D3B7332AA19275AFA1F8EC0B60FB6F66CC23AE4870791D5982AAD1AA9485FD8F4A60126FEB2CF05DB8A7F0F09B3397F3937F2E90B9E5B9C9B6EFEF642BC48351C46FB171B9BFA9EF17A961CE96C7E7A7CC3D3D03DFAD1078BA21DA425198F07D2481622BCE45969D9C4D6063D72AB7A0F08B2F49A7CC6AF335E08C4720E31476B67299E231F8BD90B39AC3AE3BE0C6B6CACEF8289A2E2873D58E51E029CAFBD55E6841489AB66B5B4B9BA6E2F784660896AFF387D92844CCB8B69475496DE19DA2E58259B090489AC8E62363CDF82CFD8EF2A427ABCD65750B506F56DDE3B988567A88126B914D7828E2B63A6D7ED0747EC59E0E0A23CE7D8A74C1D2C2A7AFB6A29799620F00E11C33787F7DED3B30E1A22D09F1FBDA1ABBBFBF25CAE05A13F812E34563F99410E73B),
      256,3072,128
      );

  DsaParameters _parameters;
  BigInteger _g;
  BigInteger _q;
  BigInteger _p;

  Dsa([DsaParameters parameters]){
    if (parameters == null){
      parameters = parameters3072;
    }
    _parameters = parameters;
    _g = _parameters.g;
    _q = _parameters.q;
    _p = _parameters.p;
  }

  DsaSignature sign(ByteArray message, BigInteger privateKey){
    BigInteger k = _randomBitsLessThan(_parameters.n,_q);
    BigInteger km1 = k.modInverse(_q);
    BigInteger r = _g.modPow(k, _p).mod(_q);

    BigInteger s = (km1 * (_hash(message) + (privateKey * r))) % _q;
    return new DsaSignature(r,s);
  }

  void verify(ByteArray message, DsaSignature signature, BigInteger publicKey){
    if (!(BigInteger.ZERO < signature.r && signature.r < _q)){
      throw new InvalidSignatureException("Invalid r: !0 < r< q: ${signature.r}");
    }
    if (!(BigInteger.ZERO < signature.s && signature.s < _q)){
      throw new InvalidSignatureException("Invalid s: !0 < s< q: ${signature.s}");
    }
    BigInteger w = signature.s.modInverse(_q);
    BigInteger z = _hash(message);
    BigInteger u1 = ((z * w) % _q);
    BigInteger u2 = ((signature.r * w) % _q);
    BigInteger v = ((_g.modPow(u1,_p)*publicKey.modPow(u2,_p))%_p)%_q;
    if (v != signature.r){
      throw new InvalidSignatureException("v != r");
    }
  }

  static BigInteger _hash(ByteArray message){
    SHA256 hashFunction = new SHA256();
    hashFunction.add(byteArrayToByteList(message));
    List<int> hash = hashFunction.close();
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
   * Appendix B.1.1
   * Insecure because randomn number generator is insecure
   */
  DsaKeyPair generateInsecureKeyPair() {
    BigInteger c = _randomBitsLessThan(_parameters.n + 64,new BigInteger(1<<(_parameters.n + 66)));
    BigInteger x = c.mod(_q-BigInteger.ONE) + BigInteger.ONE;
    BigInteger y = _g.modPow(x, _p);
    return new DsaKeyPair(x,y);
  }
  /**
   * Generate a DsaKeyPair from a cryptographically secure secret.
   * The DSA private key may not have the same bits as the secret as DSA imposes certain constraints
   * consequently you must use the privateKey from the DsaKeyPair rather than using the secret you provided.
   */
  DsaKeyPair fromSecret(BigInteger secret){
    //It is not so simple as doing a bitLenght comparison as the first few bits may be 0.
    // consequently all checks would be probablistic, however we can check that there are at least
    // numBits - 64 and have a vanishingly small probability of incorrectly failing.
    if (secret.bitLength() < _q.bitLength() - 64) {
      throw new ArgumentError("Insufficiently many bits in secret: was ${secret.bitLength()} but expected at least ${_q.bitLength() -64}. There is a 1 in 2^64 probability of this being an incorrect failure.");
    }
    BigInteger x = secret.mod(_q-BigInteger.ONE) + BigInteger.ONE;
    BigInteger y = _g.modPow(x,_p);
    return new DsaKeyPair(x,y);
  }
}
class InvalidSignatureException implements Exception {
  final String msg;
  InvalidSignatureException(this.msg);
  String toString() => msg;
}
class DsaException implements Exception {
  final String msg;
  const DsaException(this.msg);
  String toString() => msg;
}

class DsaParameters {
  final BigInteger g;
  final BigInteger q;
  final BigInteger p;
  final int n;
  final int l;
  final int strength;
  DsaParameters(this.p,this.q,this.g,this.n,this.l,this.strength);
}

class DsaSignature {
  final BigInteger r;
  final BigInteger s;
  DsaSignature(this.r,this.s);
  String toString() => "(${r},${s})";
}

class DsaKeyPair {
  final BigInteger privateKey;
  final BigInteger publicKey;
  DsaKeyPair(this.privateKey,this.publicKey);
}