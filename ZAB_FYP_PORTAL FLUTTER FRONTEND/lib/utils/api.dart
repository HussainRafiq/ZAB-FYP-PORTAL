// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lmsv4_flutter_app/constants/local_storage.dart';
import 'package:lmsv4_flutter_app/exceptions/connection_failed_exception.dart';
import 'package:lmsv4_flutter_app/exceptions/generic_message_exception.dart';
import 'package:lmsv4_flutter_app/utils/globals.dart';
import 'package:lmsv4_flutter_app/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ua_client_hints/ua_client_hints.dart';

import '../constants/urls.dart';
import '../state/auth.module.dart';

/// API Helper class that encapslates all API related functions.
class APIHelper {
  static Map<String, String> headers = {
    "AuthToken": Globals.AuthToken.toString(),
    "Platform": !kIsWeb
        ? (Platform.isAndroid
            ? "ANDROID"
            : Platform.isIOS
                ? "IOS"
                : "DESKTOP_WEB")
        : "DESKTOP_WEB"
  };

  static Future<dynamic> makeFileUploadCall(String url,
      {XFile? file, Map<String, String>? body}) async {
    var stream = http.ByteStream(file!.openRead());
    var length = await file.length();
    var prefs = await SharedPreferences.getInstance();

    await prepareHeaders("Multipart/form-data", false, true, prefs);

    var request = http.MultipartRequest("POST", Uri.parse(url));
    var multipartFile =
        http.MultipartFile('file', stream, length, filename: file.name);
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    if (body != null) request.fields.addAll(body);
    var response = await request.send();
    if (response.statusCode == HttpStatus.created) {
      var body =
          jsonDecode(String.fromCharCodes(await response.stream.toBytes()));
      return body;
    }
  }

  /// Makes an API call to the URL specified.
  static Future<dynamic> makeAPICall(
    String url, {
    String method = HTTPMethod.GET,
    String? body,
    bool isLoginApi = false,
    bool isAuthorizeApi = false,
    String contentType = "application/json",
  }) async {
    var prefs = await SharedPreferences.getInstance();

    await prepareHeaders(contentType, isLoginApi, isAuthorizeApi, prefs);
    print("headers");
    print(headers);

    var response;

    switch (method) {
      case HTTPMethod.GET:
        response = await http.get(Uri.parse(url), headers: headers).then((res) {
          print(res.body);
          print("resbody");
          if (res.statusCode == HttpStatus.ok) {
            return jsonDecode(res.body);
          } else {
            return handleError(res, prefs, url, method, body, isLoginApi,
                isAuthorizeApi, contentType);
          }
        }).catchError((e) {
          if (e is SocketException) {
            throw ConnectionFailedException();
          }
          throw e;
        });
        break;
      case HTTPMethod.POST:
        response = await http
            .post(Uri.parse(url), headers: headers, body: body)
            .then((res) {
          print(res.body);
          if (res.statusCode == HttpStatus.ok) {
            return jsonDecode(res.body);
          } else {
            return handleError(res, prefs, url, method, body, isLoginApi,
                isAuthorizeApi, contentType);
          }
        }).catchError((e) {
          if (e is SocketException) {
            throw ConnectionFailedException();
          }
          throw e;
        });
        break;
      case HTTPMethod.PUT:
        response = await http
            .put(Uri.parse(url), headers: headers, body: body)
            .then((res) {
          if (res.statusCode == HttpStatus.ok) {
            return jsonDecode(res.body);
          } else {
            return handleError(res, prefs, url, method, body, isLoginApi,
                isAuthorizeApi, contentType);
          }
        }).catchError((e) {
          if (e is SocketException) {
            throw ConnectionFailedException();
          }
          throw e;
        });
        break;
      case HTTPMethod.DELETE:
        response = await http
            .delete(Uri.parse(url), headers: headers, body: body)
            .then((res) {
          if (res.statusCode == HttpStatus.ok) {
            return jsonDecode(res.body);
          } else {
            return handleError(res, prefs, url, method, body, isLoginApi,
                isAuthorizeApi, contentType);
          }
        }).catchError((e) {
          if (e is SocketException) {
            throw ConnectionFailedException();
          }
          throw e;
        });
        break;
    }
    Logger.Log(LogType.EXTRA, "RequestUrl", url);
    Logger.Log(LogType.EXTRA, "Headers", headers);
    Logger.Log(LogType.EXTRA, "Response", response);

    return response;
  }

  /// Prepares headers for the API call.
  ///
  /// Adds [DeviceToken] and [Authorization] headers.
  static Future<void> prepareHeaders(String contentType, bool isLoginApi,
      bool isAuthorizeApi, SharedPreferences prefs) async {
    headers["Content-Type"] = contentType;
    if (isAuthorizeApi) {
      String? token = prefs.getString(TOKEN_KEY);
      print(token);
      if (token != null) {
        headers['x-access-token'] = "$token";
      }
    }

    bool isAndroidOrIOS = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    if (isAndroidOrIOS) {
      var ua = await userAgent();
      Logger.Log(LogType.EXTRA, "UserAgent: ", ua);
      headers["User-Agent"] = ua;
    }
  }

  /// Checks the validity of the token and whether it has expired or is invalid. Calls [regenerateToken] respectively.
  static bool checkTokenInvalid(Response response, SharedPreferences prefs) {
    bool isTokenInvalid = response.headers.containsKey('www-authenticate')
        ? response.headers['www-authenticate']!.contains("invalid_token") ||
            response.headers['www-authenticate']!.startsWith("Bearer")
        : false;
    bool isTokenExpired = response.headers.containsKey('tokenexpired');
    return (isTokenInvalid || isTokenExpired);
  }

  /// Regenrates expired token
  static Future<bool> regenerateToken() async {
    // var prefs = await SharedPreferences.getInstance();
    // String? oldToken = prefs.getString("token");

    // headers['Content-Type'] = 'application/json';
    // headers['OldUserAuthenticationToken'] = oldToken ?? oldToken as String;

    // var response = http
    //     .get(Uri.parse(Globals.APIUrl + REGENERATE_USER_TOKEN),
    //         headers: headers)
    //     .then((res) {
    //   if (res.statusCode != HttpStatus.ok) {
    //     AuthState().logout();
    //     throw Exception('Session Expired!');
    //   } else {
    //     var newToken = jsonDecode(res.body).payload;
    //     if (newToken) prefs.setString('token', newToken);
    //     return true;
    //   }
    // }).catchError((e) {
    //   //print(e);
    //   AuthState().logout();
    // });
    // return response;
    return false;
  }

  /// Handles errors in API calls and takes action accordingly.
  static dynamic handleError(
    Response res,
    SharedPreferences prefs,
    String url,
    String method,
    String? body,
    bool isLoginApi,
    bool isAuthorizeApi,
    String contentType,
  ) {
    if (isAuthorizeApi && checkTokenInvalid(res, prefs)) {
      return regenerateToken().then((isRegen) {
        if (isRegen) {
          return makeAPICall(url,
                  method: method,
                  body: body,
                  isLoginApi: isLoginApi,
                  contentType: contentType)
              .then((response) {
            return response;
          });
        }
        prefs.setInt('last_token_time', DateTime.now().millisecondsSinceEpoch);
      }).catchError((e) {});
    } else {
      print(res.body != null &&
          (jsonDecode(res.body) as Map).containsKey("code"));
      if (res.body != null &&
          (jsonDecode(res.body) as Map).containsKey("code")) {
        var response = jsonDecode(res.body) as Map;
        throw GenericMessageException(
            response["code"]?.toString() ?? "", response["message"] ?? "");
      }
      return jsonDecode(res.body);
    }
  }
}

class HTTPMethod {
  static const GET = "GET";
  static const POST = "POST";
  static const PUT = "PUT";
  static const DELETE = "DELETE";
}
