
part of nigori;

//TODO(drt24) deal with optional parameters using null

class AuthenticateRequest {
  String public_key;
  String sig;
  String nonce;
  String server_name;
  AuthenticateRequest(ByteArray public_key,ByteArray sig,ByteArray nonce, String server_name){
    this.public_key = base64Encode(public_key);
    this.sig = base64Encode(sig);
    this.nonce = base64Encode(nonce);
    this.server_name = server_name;
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
  bool operator ==(RevisionValue rv){
    if (rv is! RevisionValue){
      return false;
    }
    if (rv == null){
      return false;
    }
    return this.revision == rv.revision && this.value == rv.value;
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
class GetResponse extends JsonObject {
  GetResponse(List<RevisionValue> revisions, ByteArray key){
    this.key = base64Encode(key);
    this['key'] = this.key;
    this['revisions'] = revisions;
    this.isExtendable = false;
  }
  GetResponse._empty();
  factory GetResponse.fromJsonString(String json){
    GetResponse response = new JsonObject.fromJsonString(json,new GetResponse._empty());
    List<RevisionValue> revisions = new List.fixedLength(response.revisions.length);
    for (int i = 0; i< revisions.length; ++i){
      Map map = response.revisions[i];
      revisions[i] = new RevisionValue(base64Decode(map['revision']),base64Decode(map['value']));
    }
    response.revisions = revisions;
    response.key = response.key;
    return response;
  }
  String toString() => "";
}

class GetIndicesRequest {
  final AuthenticateRequest auth;
  GetIndicesRequest(this.auth);
}
class GetIndicesResponse extends JsonObject {
  List<String> indices;
  GetIndicesResponse(List<ByteArray> indices){
    this.indices = base64EncodeList(indices);
    this['indices'] = this.indices;
  }
  GetIndicesResponse._empty();
  factory GetIndicesResponse.fromJsonString(String json){
    GetIndicesResponse response = new JsonObject.fromJsonString(json, new GetIndicesResponse._empty());
    response.indices = response['indices'];
    return response;
  }
}

class GetRevisionsRequest {
  final AuthenticateRequest auth;
  String key;
  GetRevisionsRequest(this.auth, ByteArray key){
    this.key = base64Encode(key);
  }
}
class GetRevisionsResponse extends JsonObject {
  List<String> revisions;
  String key;
  GetRevisionsResponse(List<ByteArray> revisions, ByteArray key) {
    this.revisions = base64EncodeList(revisions);
    this.key = base64Encode(key);
    this['revisions'] = this.revisions;
    this['key'] = this.key;
  }
  GetRevisionsResponse._empty();
  factory GetRevisionsResponse.fromJsonString(String json){
    GetRevisionsResponse response = new JsonObject.fromJsonString(json,new GetRevisionsResponse._empty());
    response.revisions = response['revisions'];
    response.key = response['key'];
    return response;
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