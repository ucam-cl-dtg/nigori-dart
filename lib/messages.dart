
part of nigori;

//TODO(drt24) deal with optional parameters using null

class AuthenticateRequest {
  String public_key;
  String sig;
  String nonce;
  String server_name;
  AuthenticateRequest(ByteArray public_key,ByteArray sig,ByteArray nonce,ByteArray server_name){
    this.public_key = base64Encode(public_key);
    this.sig = base64Encode(sig);
    this.nonce = base64Encode(nonce);
    this.server_name = base64Encode(server_name);
  }
}
class RegisterRequest {
  String public_key;
  String token;
  RegisterRequest(ByteArray public_key,ByteArray token){
    this.public_key = base64Encode(public_key);
    this.token = base64Encode(token);
  }
}
class UnregisterRequest {
  final AuthenticateRequest auth;
  UnregisterRequest(this.auth);
}
class RevisionValue {
  String revision;
  String value;
  RevisionValue(ByteArray revision,ByteArray value){
    this.revision = base64Encode(revision);
    this.value = base64Encode(value);
  }
}

class GetRequest {
  final AuthenticateRequest auth;
  String key;
  String revision;
  GetRequest(this.auth,ByteArray key,ByteArray revision){
    this.key = base64Encode(key);
    this.revision = base64Encode(revision);
  }
}
class GetResponse {
  final List<RevisionValue> revisions;
  String key;
  GetResponse(this.revisions,ByteArray key){
    this.key = base64Encode(key);
  }
}

class GetIndicesRequest {
  final AuthenticateRequest auth;
  GetIndicesRequest(this.auth);
}
class GetIndicesResponse {
  List<String> indices;
  GetIndicesResponse(List<ByteArray> indices){
    this.indices = base64EncodeList(indices);
  }
}

class GetRevisionsRequest {
  final AuthenticateRequest auth;
  String key;
  GetRevisionsRequest(this.auth, ByteArray key){
    this.key = base64Encode(key);
  }
}
class GetRevisionsResponse {
  List<String> revisions;
  String key;
  GetRevisionsResponse(List<ByteArray> revisions, ByteArray key) {
    this.revisions = base64EncodeList(revisions);
    this.key = base64Encode(key);
  }
}

class PutRequest {
  final AuthenticateRequest auth;
  String key;
  String revision;
  String value;
  PutRequest(this.auth,ByteArray key,ByteArray revision,ByteArray value){
    this.key = base64Encode(key);
    this.revision = base64Encode(revision);
    this.value = base64Encode(value);
  }
}
class DeleteRequest {
  final AuthenticateRequest auth;
  String key;
  String revision;
  DeleteRequest(this.auth,ByteArray key,ByteArray revision){
    this.key = base64Encode(key);
    this.revision = base64Encode(revision);
  }
}