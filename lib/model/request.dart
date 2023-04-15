import 'dart:convert';
import 'package:stylish_wen/data/hots.dart';
import 'package:dio/dio.dart';

// ignore: constant_identifier_names
enum RequestMethod { GET, POST }

abstract class Request<T> {
  late RequestMethod method;
  late String endpoint;
  late Map<String, dynamic> queries;
  late ResponseType type;

  T decode(Map<dynamic, dynamic> json);
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
  ResponseType get type {
    return ResponseType.json;
  }

  @override
  List<Hots> decode(Map<dynamic, dynamic> json) {
    Iterable l = json['data'];
    return List<Hots>.from(l.map((model) => Hots.fromJson(model)));
  }
}
