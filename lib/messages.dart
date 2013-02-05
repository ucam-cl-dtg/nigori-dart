
part of nigori;

class AuthenticateRequest {
  final ByteArray public_key;
  final ByteArray sig;
  final ByteArray nonce;
  final ByteArray server_name;
  AuthenticateRequest(this.public_key,this.sig,this.nonce,this.server_name);
}
class RegisterRequest {
  final ByteArray public_key;
  final ByteArray token;
  RegisterRequest(this.public_key,this.token);
}
class UnregisterRequest {
  final AuthenticateRequest auth;
  UnregisterRequest(this.auth);
}
class RevisionValue {
  final ByteArray revision;
  final ByteArray value;
  RevisionValue(this.revision,this.value);
}

class GetRequest {
  final AuthenticateRequest auth;
  final ByteArray key;
  final ByteArray revision;
  GetRequest(this.auth,this.key,this.revision);
}
class GetResponse {
  final List<RevisionValue> revisions;
  final ByteArray key;
  GetResponse(this.revisions,this.key);
}

class GetIndicesRequest {
  final AuthenticateRequest auth;
  GetIndicesRequest(this.auth);
}
class GetIndicesResponse {
  final List<ByteArray> indices;
  GetIndicesResponse(this.indices);
}

class GetRevisionsRequest {
  final AuthenticateRequest auth;
  final ByteArray bytes;
  GetRevisionsRequest(this.auth, this.bytes);
}
class GetRevisionsResponse {
  final List<ByteArray> revisions;
  final ByteArray key;
  GetRevisionsResponse(this.revisions,this.key);
}

class PutRequest {
  final AuthenticateRequest auth;
  final ByteArray key;
  final ByteArray revision;
  final ByteArray value;
  PutRequest(this.auth,this.key,this.revision,this.value);
}
class DeleteRequest {
  final AuthenticateRequest auth;
  final ByteArray key;
  final ByteArray revision;
  DeleteRequest(this.auth,this.key,this.revision);
}