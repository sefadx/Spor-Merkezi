import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:silivri_havuz/model/file_model.dart';

import '../utils/enums.dart';

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

  String upload() => "$_baseAPI/upload";

  String variables() => "$_baseAPI/variables";

  String login() => "$_baseAPI/login";

  String member({int page = 1, int limit = 10, String search = ""}) =>
      "$_baseAPI/member?page=${page.toString()}&limit=${limit.toString()}&search=$search";
  String memberId({required String memberId}) => "$_baseAPI/member/$memberId";

  String session({int page = 1, int limit = 10}) => "$_baseAPI/session?page=${page.toString()}&limit=${limit.toString()}";

  String subscription({SportTypes? sportType, DateTime? endDate}) {
    String url = "$_baseAPI/subscription?";
    if (endDate != null) url += "endDate=${endDate.toIso8601String()}&";
    if (sportType != null) url += "sportType=${sportType.toString()}";
    return url;
  }

  String trainer({String? search}) {
    String url = "$_baseAPI/trainer?";
    if (search != null) url += "search=$search";
    return url;
  }
}

class APIService<T extends JsonProtocol> {
  APIService({required this.url});

  ///url: APIS.api.member()
  final String url;

  dynamic safeJsonDecode(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      throw APIError(Errors.decodeDataError, "JSON parse hatası: $e");
    }
  }

  /// If fetch model list (all parsed)
  ///final response = await APIService<ListWrapped<MemberModel>>(
  ///   url: APIS.api.member(page: 1, limit: 20)
  /// ).get(
  ///   fromJsonT: (json) => ListWrapped.fromJson(
  ///     jsonList: json, // json burada List<dynamic> olacak
  ///     fromJsonT: (item) => MemberModel.fromJson(json: item),
  ///   )
  /// );
  /// If fetch 1 model (no list) (parsed)
  ///final response = await APIService<MemberModel>(
  ///   url: APIS.api.memberId(memberId: "someId")
  /// ).getBaseResponseModel(
  ///   fromJsonT: (json) => MemberModel.fromJson(json: json)
  /// );
  Future<BaseResponseModel<T>> get({T Function(dynamic json)? fromJsonT, String username = "", String password = ""}) async {
    try {
      Response res = await http.get(Uri.parse(url),
          headers: {"Content-Type": "application/json; charset=UTF-8", "Accept": "application/json"}).onError((error, stackTrace) {
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

      return BaseResponseModel<T>.fromJson(map: jsonDecode(res.body), fromJsonT: fromJsonT);
      //return BaseResponseModel.fromJson(map: {"status": true, "message": "mesaj", "data": {"name": "isim"}},data: data);
    } on APIError catch (err) {
      debugPrint("API ERROR: ${err.error}");
      throw APIError(err.message);
    } on FormatException catch (err) {
      debugPrint(err.message);
      throw FormatException(err.message);
    } on Exception catch (err) {
      debugPrint(err.toString());
      throw APIError(Errors.decodeDataError);
    }
  }

  Future<BaseResponseModel<T?>> post(T model, {T Function(dynamic json)? fromJsonT, String username = "", String password = ""}) async {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    debugPrint("auth: $basicAuth");
    debugPrint("API'ye giden veri: ${model.toJson()}");
    try {
      Response res = await http
          .post(Uri.parse(url),
              //headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': basicAuth},
              headers: {"Content-Type": "application/json; charset=UTF-8", "Accept": "application/json", "Authorization": basicAuth},
              body: jsonEncode(model.toJson()))
          //body: jsonEncode({"username": "14528993102@silivri.bel.tr", "password": "xxx-xxx-xxx"}))
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

  Future<BaseResponseModel<T?>> put(T model, {T Function(dynamic json)? fromJsonT, String username = "", String password = ""}) async {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    debugPrint("auth: $basicAuth");
    debugPrint("API'ye giden veri: ${model.toJson()}");
    try {
      Response res = await http
          .put(Uri.parse(url),
              //headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': basicAuth},
              headers: {"Content-Type": "application/json; charset=UTF-8", "Accept": "application/json", "Authorization": basicAuth},
              body: jsonEncode(model.toJson()))
          //body: jsonEncode({"username": "14528993102@silivri.bel.tr", "password": "xxx-xxx-xxx"}))
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

  Future<BaseResponseModel<T?>> delete(T model, {T Function(dynamic json)? fromJsonT, String username = "", String password = ""}) async {
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    debugPrint("auth: $basicAuth");
    debugPrint("API'ye giden veri: ${model.toJson()}");
    try {
      Response res = await http
          .delete(Uri.parse(url),
              //headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8', 'Authorization': basicAuth},
              headers: {"Content-Type": "application/json; charset=UTF-8", "Accept": "application/json", "Authorization": basicAuth},
              body: jsonEncode(model.toJson()))
          //body: jsonEncode({"username": "14528993102@silivri.bel.tr", "password": "xxx-xxx-xxx"}))
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

  Future<BaseResponseModel<T?>> uploadFile(
    T model, {
    T Function(dynamic json)? fromJsonT,
    required String filePath,
    // API'de kullanılan form field adı (örneğin: "file")
    String username = "",
    String password = "",
  }) async {
    try {
      // Dosya boyutu kontrolü
      final fileObj = File(filePath);
      final fileSize = await fileObj.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      debugPrint("Yüklenecek dosya: $filePath, Boyut: ${fileSizeMB.toStringAsFixed(2)}MB");

      // MultipartRequest oluştur
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Authentication header'ları ekle (varsa)
      if (username.isNotEmpty && password.isNotEmpty) {
        String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
        request.headers["Authorization"] = basicAuth;
      }

      // Content type, API'den JSON yanıt almak istediğimizi belirt
      request.headers["Accept"] = "application/json";

      // Dosyayı ekleyelim
      final fileName = path.basename(filePath);
      debugPrint("========= DOSYA YÜKLEME DETAYLARI =========");
      debugPrint("Dosya yolu: $filePath");
      debugPrint("Dosya adı: $fileName");

      // MultipartFile oluştur - API'nin beklediği field name'i kullanarak
      // MultipartFile oluştur - API'nin beklediği field name ile "file" kullan
      // NOT: Bu değer backend'deki upload.single("file") ile aynı olmalı
      var file = await http.MultipartFile.fromPath(
          "file", // Mutlaka "file" kullanıyoruz, değişken değil
          filePath,
          filename: fileName,
          contentType: MediaType.parse("application/pdf"));
      request.files.add(file);
      debugPrint("Dosya eklendi: ${file.length} bytes");

      // Ekstra form alanları
      if (model != null) {
        debugPrint("Form alanları ekleniyor: $model");
        request.fields.addAll(Map<String, String>.from(model.toJson()));
      }
      // İsteği gönder
      debugPrint("Dosya yükleme isteği gönderiliyor: $url");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint("Yanıt içeriği: ${response.body}");

      // HTTP durum kodunu kontrol et
      /*if (response.statusCode >= 400) {
        try {
          // Sunucu JSON hata yanıtı döndürmüş mü kontrol et
          final errorDecoded = jsonDecode(response.body);
          if (errorDecoded is Map<String, dynamic> && errorDecoded.containsKey('message')) {
            throw APIError(errorDecoded['message']);
          }
        } catch (_) {
          // JSON parse hatası olabilir, genel hata mesajı döndür
        }
        throw APIError(Errors.dataError, "Dosya yükleme başarısız. HTTP kodu: ${response.statusCode}");
      }*/

      // Başarılı yanıt parse edilmesi
      try {
        //final decoded = jsonDecode(response.body);
        final decoded = safeJsonDecode(response.body);
        if (decoded is! Map<String, dynamic>) {
          throw APIError(Errors.invalidResponseStatus);
        }

        return BaseResponseModel.fromJson(map: decoded);
      } catch (e) {
        debugPrint("JSON parse hatası: $e");
        throw APIError(Errors.decodeDataError);
      }
    } on APIError catch (err) {
      debugPrint("API hatası: ${err.message}");
      throw APIError(err.message);
    } on FormatException catch (err) {
      debugPrint(err.message);
      throw FormatException(err.message);
    } on Exception catch (err) {
      debugPrint(err.toString());
      throw APIError(Errors.decodeDataError);
    }
  }

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

  Future postJson(Map<String, dynamic> map) async {
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

  factory BaseResponseModel.fromJson({required Map<String, dynamic> map, T Function(dynamic json)? fromJsonT}) {
    try {
      T? data;
      debugPrint("Base Response Data type: $T");
      data = fromJsonT != null ? fromJsonT(map["data"]) : null;
      debugPrint("Base Response Data type: ${data.toString()}");
      return BaseResponseModel(success: map["success"], message: map["message"], data: data);
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
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

class ListWrapped<T extends JsonProtocol> implements JsonProtocol {
  final List<T> items;
  ListWrapped(this.items);

  factory ListWrapped.fromJson({required List<dynamic> jsonList, required T Function(Map<String, dynamic>) fromJsonT}) {
    //debugPrint("ListWrapped : $jsonList");
    try {
      List<T> items = jsonList.map((json) => fromJsonT(json)).toList();
      return ListWrapped<T>(items);
    } catch (err) {
      debugPrint(err.toString());
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "data": items.map((item) => item.toJson()).toList(),
    };
  }
}
