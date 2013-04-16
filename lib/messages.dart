
part of nigori;

//TODO(drt24) deal with optional parameters using null

class AuthenticateRequest extends JsonObject {
  String public_key;
  String sig;
  String nonce;
  String server_name;
  AuthenticateRequest(ByteData public_key, ByteData sig, ByteData nonce, String server_name){
    this.public_key = base64Encode(public_key);
    this['public_key'] = this.public_key;
    this.sig = base64Encode(sig);
    this['sig'] = this.sig;
    this.nonce = base64Encode(nonce);
    this['nonce'] = this.nonce;
    this.server_name = server_name;
    this['server_name'] = this.server_name;
  }
}
class RegisterRequest {
  String public_key;
  String token;
  RegisterRequest(ByteData public_key, ByteData token){
    this.public_key = base64Encode(public_key);
    this.token = base64Encode(token);
  }
}
class UnregisterRequest extends JsonObject {
  final AuthenticateRequest auth;
  UnregisterRequest(this.auth) {
    this['auth'] = this.auth;
  }
}
class RevisionValue {
  String revision;
  String value;
  RevisionValue(ByteData revision, ByteData value){
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

class GetRequest extends JsonObject {
  final AuthenticateRequest auth;
  String key;
  String revision;
  GetRequest(this.auth, ByteData key, ByteData revision){
    this['auth'] = this.auth;
    this.key = base64Encode(key);
    this['key'] = this.key;
    this.revision = base64Encode(revision);
    this['revision'] = this.revision;
  }
}
class GetResponse extends JsonObject {
  String key;
  List<RevisionValue> revisions;
  GetResponse(List<RevisionValue> revisions, ByteData key){
    this.key = base64Encode(key);
    this.revisions = revisions;
    this['key'] = this.key;
    this['revisions'] = revisions;
    this.isExtendable = false;
  }
  GetResponse._empty();
  factory GetResponse.fromJsonString(String json){
    GetResponse response = new JsonObject.fromJsonString(json,new GetResponse._empty());
    List<RevisionValue> revisions = new List.fixedLength(response['revisions'].length);
    for (int i = 0; i< revisions.length; ++i){
      Map map = response['revisions'][i];
      String revision = map['revision'];
      String value = map['value'];
      revisions[i] = new RevisionValue(base64Decode(revision),base64Decode(value));
    }
    response.revisions = revisions;
    response.key = response['key'];
    return response;
  }
  String toString() => "";
}

class GetIndicesRequest extends JsonObject {
  final AuthenticateRequest auth;
  GetIndicesRequest(this.auth){
    this['auth'] = this.auth;
  }
}
class GetIndicesResponse extends JsonObject {
  List<String> indices;
  GetIndicesResponse(List<ByteData> indices){
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

class GetRevisionsRequest extends JsonObject {
  final AuthenticateRequest auth;
  String key;
  GetRevisionsRequest(this.auth, ByteData key){
    this['auth'] = this.auth;
    this.key = base64Encode(key);
    this['key'] = this.key;
  }
}
class GetRevisionsResponse extends JsonObject {
  List<String> revisions;
  String key;
  GetRevisionsResponse(List<ByteData> revisions, ByteData key) {
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

class PutRequest extends JsonObject {
  final AuthenticateRequest auth;
  String key;
  String revision;
  String value;
  PutRequest(this.auth, ByteData key, ByteData revision, ByteData value){
    this['auth'] = this.auth;
    this.key = base64Encode(key);
    this['key'] = this.key;
    this.revision = base64Encode(revision);
    this['revision'] = this.revision;
    this.value = base64Encode(value);
    this['value'] = this.value;
  }
}
class DeleteRequest extends JsonObject {
  final AuthenticateRequest auth;
  String key;
  //String revision;
  DeleteRequest(this.auth, ByteData key,[ByteData revision]){
    this.key = base64Encode(key);
    this['auth'] = this.auth;
    this['key'] = this.key;
    if (revision != null){
      this['revision'] = base64Encode(revision);
    }
  }
}