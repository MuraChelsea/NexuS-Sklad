import 'json_reader.dart';

typedef TransportDecoder<TTransport> = TTransport Function(JsonMap json);
typedef DomainMapper<TTransport, TDomain> = TDomain Function(TTransport transport);

TDomain mapTransport<TTransport, TDomain>(
  JsonMap json, {
  required TransportDecoder<TTransport> decodeTransport,
  required DomainMapper<TTransport, TDomain> toDomain,
}) {
  return toDomain(decodeTransport(json));
}
