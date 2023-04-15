import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stylish_wen/data/hots.dart';

const host = 'api.appworks-school.tw';
const apiVersion = '1.0';

// ignore: constant_identifier_names
enum RequestMethod { GET, POST }

abstract class Request<T> {
  late RequestMethod method;
  late String endpoint;
  late Map<String, dynamic> queries;
  Uri makeRequest() {
    return Uri.https(host, '/api/$apiVersion/$endpoint', queries);
  }

  T decode(String json);
}

class HostRequest extends Request {
  @override
  RequestMethod get method {
    return RequestMethod.GET;
  }

  @override
  String get endpoint {
    return '/marketing/hots';
  }

  @override
  Map<String, dynamic> get queries {
    return {};
  }

  @override
  List<Hots> decode(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    Iterable l = map['data'];
    return List<Hots>.from(l.map((model) => Hots.fromJson(model)));
  }
}
