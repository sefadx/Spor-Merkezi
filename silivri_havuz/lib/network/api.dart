import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:silivri_havuz/model/member_model.dart';

enum Errors {
  invalidUrl,
  invalidResponseStatus,
  taskError,
  dataError,
  decodeDataError;

  @override
  String toString() {
    switch (this) {
      case Errors.dataError:
        return "The data provided appears to be corrupt";
      case Errors.decodeDataError:
        return "Decode Data Error";
      case Errors.invalidResponseStatus:
        return "The API failed to issue a valid response";
      case Errors.invalidUrl:
        return "The endpoint URL is invalid";
      case Errors.taskError:
        return "Task Error";
      default:
        return "null";
    }
  }
}

class APIError implements Exception {
  final dynamic message;
  APIError(this.error, [this.message]);

  Errors error;

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) {
      switch (error) {
        case Errors.dataError:
          return "The data provided appears to be corrupt";
        case Errors.decodeDataError:
          return "Decode Data Error";
        case Errors.invalidResponseStatus:
          return "The API failed to issue a valid response";
        case Errors.invalidUrl:
          return "The endpoint URL is invalid";
        case Errors.taskError:
          return "Task Error";
        default:
          return "null";
      }
    }
    return "Exception: $message";
  }
}

class APIS {
  static APIS get api => _start;
  static final APIS _start = APIS._instance();
  APIS._instance();

  final String _baseAPI = "http://localhost:5001";
  String variables() => "$_baseAPI/variables";

  String member({int page = 1, int limit = 10, String search = ""}) =>
      "$_baseAPI/member?page=${page.toString()}&limit=${limit.toString()}&search=$search";
  String memberId({required String memberId}) => "$_baseAPI/member/$memberId";

  String session({int page = 1, int limit = 10}) => "$_baseAPI/session?page=${page.toString()}&limit=${limit.toString()}";
}

class APIService<T extends JsonProtocol> {
  APIService({required this.url});

  ///url: APIS.api.member()
  final String url;

  Future getJson() async {
    try {
      Response res = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        throw APIError(Errors.invalidUrl);
      });
      if (res.statusCode != 200) {
        throw APIError(Errors.invalidResponseStatus);
      }
      debugPrint(jsonDecode(res.body).toString());
      return jsonDecode(res.body);
    } on APIError catch (err) {
      debugPrint(err.message);
      throw APIError(err.message);
    } on FormatException catch (err) {
      debugPrint(err.message);
      throw FormatException(err.message);
    } on Exception catch (err) {
      debugPrint(err.toString());
      throw APIError(Errors.decodeDataError);
    }
  }

  Future<BaseResponseModel<T>> getBaseResponseModel() async {
    try {
      Response res = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        throw APIError(Errors.invalidUrl);
      });
      debugPrint("API'den gelen veri: ${res.body}");
      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) {
        //debugPrint(decoded);
        //debugPrint(decoded.runtimeType.toString());
        throw APIError(Errors.invalidResponseStatus);
      }

      return BaseResponseModel<T>.fromJson(map: jsonDecode(res.body));
      //return BaseResponseModel.fromJson(map: {"status": true, "message": "mesaj", "data": {"name": "isim"}},data: data);
    } on APIError catch (err) {
      debugPrint("API ERROR");
      throw APIError(err.message);
    } on FormatException catch (err) {
      debugPrint(err.message);
      throw FormatException(err.message);
    } on Exception catch (err) {
      debugPrint(err.toString());
      throw APIError(Errors.decodeDataError);
    }
  }

  Future<BaseResponseModel> post(T model) async {
    /*String username = "muhammedeminekim";
    String password = "aa78478c2db63b63b588916b4dea47cea71d7d3b";

    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    debugPrint("auth: $basicAuth");*/
    debugPrint("API'ye giden veri: ${model.toJson()}");
    try {
      Response res = await http
          .post(Uri.parse(url),
              //headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'authorization': basicAuth},
              headers: {"Content-Type": "application/json", "Accept": "application/json"},
              body: jsonEncode(model.toJson()))
          .onError((error, stackTrace) {
        debugPrint(error.toString());
        throw APIError(Errors.invalidUrl);
      });

      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) {
        //debugPrint(decoded);
        //debugPrint(decoded.runtimeType.toString());
        throw APIError(Errors.invalidResponseStatus);
      }
      debugPrint("API'den gelen veri: ${res.body}");
      return BaseResponseModel.fromJson(map: jsonDecode(res.body));
    } on APIError catch (err) {
      debugPrint(err.message);
      throw APIError(err.message);
    } on FormatException catch (err) {
      debugPrint(err.message);
      throw FormatException(err.message);
    } on Exception catch (err) {
      debugPrint(err.toString());
      throw APIError(Errors.decodeDataError);
    }
  }

  Future postJsonReturnMap(Map<String, dynamic> map) async {
    /*String username = "muhammedeminekim";
    String password = "aa78478c2db63b63b588916b4dea47cea71d7d3b";

    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    debugPrint("auth: $basicAuth");*/
    debugPrint("API'ye giden veri: $map");
    try {
      Response res = await http
          .post(Uri.parse(url),
              //headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'authorization': basicAuth},
              headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
              body: jsonEncode(map))
          .onError((error, stackTrace) {
        debugPrint(error.toString());
        throw APIError(Errors.invalidUrl);
      });
      if (res.statusCode != 200) {
        throw APIError(Errors.invalidResponseStatus);
      }
      debugPrint(res.body.toString());
      return jsonDecode(res.body);
    } on APIError catch (err) {
      debugPrint(err.message);
      throw APIError(err.message);
    } on FormatException catch (err) {
      debugPrint(err.message);
      throw FormatException(err.message);
    } on Exception catch (err) {
      debugPrint(err.toString());
      throw APIError(Errors.decodeDataError);
    }
  }

  /*
  Future postJson({Type? type}) async {
    String username = "muhammedeminekim";
    String password = "aa78478c2db63b63b588916b4dea47cea71d7d3b";

    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    print("auth: $basicAuth");

    try {
      Response res = await http.post(Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': basicAuth
      },body: jsonEncode(<String, dynamic>{
        'name': nameController.text,
        'email': emailController.text,
        // Add any other data you want to send in the body
      }),).onError((error, stackTrace) {
        debugPrint(error.toString());
        throw APIError(Errors.invalidUrl);
      });
      if (res.statusCode != 200) {
        throw APIError(Errors.invalidResponseStatus);
      }
      debugPrint(res.body.toString());
      return jsonDecode(res.body);
    } on APIError catch (err) {
      debugPrint(err.message);
      throw APIError(err.message);
    } on FormatException catch (err) {
      debugPrint(err.message);
      throw FormatException(err.message);
    } on Exception catch (err) {
      debugPrint(err.toString());
      throw APIError(Errors.decodeDataError);
    }
  }
   */
}

class BaseResponseModel<T> implements JsonProtocol {
  BaseResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  bool success;
  String message;
  T? data;

  /*
  factory BaseResponseModel.fromJson({
    required Map<String, dynamic> map,
    Type? type,
  }) {
    T data;
    debugPrint("runtime type " + T.toString());
    Type myType = MemberModel;
    switch (T.toString()) {
      case MemberModel:
        data = MemberModel.fromJson(json: map) as T;
      default:
        debugPrint("default type");
        data = MemberModel.fromJson(json: map) as T;
    }*/

  factory BaseResponseModel.fromJson({required Map<String, dynamic> map}) {
    T data;
    debugPrint("Base Response Data type: $T");
    switch (T.toString()) {
      case "MemberModel":
        data = MemberModel.fromJson(json: map["data"]) as T;
      default:
        debugPrint("default type Map");
        data = map["data"];
    }

    return BaseResponseModel(success: map["success"], message: map["message"], data: data);
  }

  @override
  Map<String, dynamic> toJson() {
    return {"success": success, "message": message, "data": data.toString()};
  }
}

abstract class JsonProtocol {
  JsonProtocol();
  JsonProtocol.fromJson({
    required Map<String, dynamic> map,
  });
  Map<String, dynamic> toJson();
}

/*
enum APIError {
  invalidUrl,
  invalidResponseStatus,
  taskError,
  dataError,
  decodeDataError;

  @override
  String toString() {
    switch (this) {
      case APIError.dataError:
        return "The data provided appears to be corrupt";
      case APIError.decodeDataError:
        return "Decode Data Error";
      case APIError.invalidResponseStatus:
        return "The API failed to issue a valid response";
      case APIError.invalidUrl:
        return "The endpoint URL is invalid";
      case APIError.taskError:
        return "Task Error";
      default:
        return "null";
    }
  }
}
*/
