// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core_flutter/app/data/models/message_response.dart';
import 'package:core_flutter/app/data/models/token_response.dart';
import 'package:core_flutter/app/repository/account_repository.dart';
import 'package:core_flutter/app/repository/credential_repository.dart';
import 'package:core_flutter/app/utils/api_utils.dart';
import 'package:core_flutter/app/utils/token_utils.dart';
import 'package:core_flutter/app/widgets/app_custom_toast.dart';
import 'package:core_flutter/app/widgets/app_dialog.dart';
import 'package:core_flutter/app/widgets/custom_state_view.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:core_flutter/app/data/providers/http_client_factory.dart'
    as http_client_factory;

extension RequestExtension on http.BaseRequest {
  HttpMethod getHttpMethod(String method) {
    switch (method) {
      case "POST":
        return HttpMethod.Post;
      case "PUT":
        return HttpMethod.Put;
      case "GET":
        return HttpMethod.Get;
      case "DELETE":
        return HttpMethod.Delete;
      default:
        FirebaseCrashlytics.instance.recordFlutterError(
            FlutterErrorDetails(exception: ArgumentError("Not found method")));
        return HttpMethod.Trace;
    }
  }

  Future<ViewState<T>> toViewState<T>(T Function(Map<String, dynamic>) fromJson,
      {http.Client? customClient, bool closeEnabled = true}) async {
    // Using RetryClient to send the request with retries
    final client =
        customClient ?? RetryClient(http_client_factory.httpClient());
    final HttpMetric httpMetric = FirebasePerformance.instance.newHttpMetric(
      url.toString(),
      getHttpMethod(method),
    );
    try {
      await httpMetric.start();
      final streamResponse =
          await client.send(this).timeout(const Duration(minutes: 1));
      final response = await http.Response.fromStream(streamResponse);
      final status = _HttpStatusCode(response.statusCode);
      if (status.isOk) {
        final data = jsonDecode(response.body);
        return Success<T>(fromJson(data));
      } else if (status.isUnauthorized) {
        var isSuccess = await _regenerateToken();
        if (isSuccess) {
          return await toViewState(fromJson);
        } else {
          return Failed(
            messageResponse: MessageResponse(
              message: "Token Expired, please try again",
              statusCode: status.code,
            ),
          );
        }
      } else if (status.isForbidden) {
        _requestLogout();
        return Failed(
          messageResponse: MessageResponse(
            message: "Token Expired, please try again",
            statusCode: status.code,
          ),
        );
      } else if (status.connectionError) {
        return Failed(
          messageResponse: MessageResponse(
            message: "Error Connection",
            statusCode: status.code,
          ),
        );
      } else {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return Failed(messageResponse: MessageResponse.fromMap(data));
        } else {
          FirebaseCrashlytics.instance.recordError(response, null, fatal: true);
          return SomethingWentWrong<T>(
            Exception("SomethingWentWrong"),
          );
        }
      }
    } catch (e, stack) {
      if (e is http.ClientException) {
        return NoInternet();
      } else if (e is SocketException) {
        return NoInternet();
      } else if (e is TimeoutException) {
        return Timeout();
      } else {
        FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
        return SomethingWentWrong<T>(e);
      }
    } finally {
      if (closeEnabled) {
        client.close();
      }
      await httpMetric.stop();
    }
  }

  Future<ViewState<Map<String, dynamic>>> toViewStateJson() async {
    // Using RetryClient to send the request with retries
    final client = RetryClient(http_client_factory.httpClient());
    try {
      final streamResponse = await client.send(this);
      final response = await http.Response.fromStream(streamResponse)
          .timeout(const Duration(minutes: 1));
      final status = _HttpStatusCode(response.statusCode);
      if (status.isOk) {
        final data = jsonDecode(response.body);
        return Success<Map<String, dynamic>>(data);
      } else if (status.isUnauthorized) {
        var isSuccess = await _regenerateToken();
        if (isSuccess) {
          return await toViewStateJson();
        } else {
          return Failed(
            messageResponse: MessageResponse(
              message: "Token Expired, please try again",
              statusCode: status.code,
            ),
          );
        }
      } else if (status.connectionError) {
        return Failed(
          messageResponse: MessageResponse(
            message: "Error Connection",
            statusCode: status.code,
          ),
        );
      } else {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return Failed(messageResponse: MessageResponse.fromMap(data));
        } else {
          return SomethingWentWrong(
            Exception("Something Went Wrong"),
          );
        }
      }
    } catch (e, stack) {
      if (e is http.ClientException) {
        return NoInternet();
      } else if (e is SocketException) {
        return NoInternet();
      } else if (e is TimeoutException) {
        return Timeout();
      } else {
        FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
        return SomethingWentWrong(e);
      }
    } finally {
      client.close();
    }
  }

  Future<void> _requestLogout() async {
    final AccountRepository accountRepository = Get.find();
    final result = await accountRepository.logout();

    result.validateWithDialog((data) {
      TokenUtils.instance.showSessionExpired();
    });
  }

  Future<bool> _regenerateToken() async {
    final client = RetryClient(http_client_factory.httpClient());

    try {
      final response = await client.post(
        Uri.parse(ApiUtils.instance.mergeEndPoint(endPoint: "endPoint")),
        body: {'refreshToken': TokenUtils.instance.refreshToken.toString()},
      );
      var status = _HttpStatusCode(response.statusCode);
      if (status.isOk) {
        final successResponse =
            TokenResponse.fromMap(jsonDecode(response.body));
        final CredentialRepository credentialRepository =
            CredentialRepository();
        await credentialRepository
            .setAccessToken(successResponse.data.accessToken);
        await credentialRepository
            .setRefreshToken(successResponse.data.refreshToken);
        return true;
      } else if (status.isUnauthorized) {
        await TokenUtils.instance.showSessionExpired();
      }
    } finally {
      client.close();
    }

    return false;
  }
}

extension ResultNotSuccessExtension on ViewState<dynamic> {
  String toMessage<T>() {
    if (this is Failed<T>) {
      final result = this as Failed<T>;
      final message = result.messageResponse?.message.toString() ?? "Error";
      return message;
    }
    if (this is Timeout) {
      final message = "Timeout";
      return message;
    }
    if (this is NoInternet) {
      return "No Internet Connection";
    }
    if (this is SomethingWentWrong) {
      return "Something Went Wrong";
    }
    return "Something Went Wrong";
  }
}

extension ResultNotSuccessToastExtension on ViewState<dynamic> {
  void toastNotSuccessMessage<T>() {
    if (this is Failed<T>) {
      final result = this as Failed<T>;
      final message =
          result.messageResponse?.message.toString() ?? "SomethingWentWrong";
      CustomToast.showToast(Get.context!, message);
    }
    if (this is Timeout) {
      final message = "Timeout!";
      CustomToast.showToast(Get.context!, message);
    }
    if (this is NoInternet) {
      CustomToast.showToast(Get.context!, "No Internet Connection");
    }
    if (this is SomethingWentWrong) {
      CustomToast.showToast(Get.context!, "Something Went Wrong");
    }
  }
}

extension ValidateResultNotSuccess on ViewState<dynamic> {
  ViewState<T> toNotSuccess<T>() {
    if (this is Failed<T>) {
      final result = this as Failed<T>;
      return Failed(messageResponse: result.messageResponse);
    }
    if (this is Timeout) {
      return Timeout();
    }
    if (this is NoInternet) {
      return NoInternet();
    }
    if (this is SomethingWentWrong) {
      var error = this as SomethingWentWrong;
      return SomethingWentWrong(error.exception);
    }
    return SomethingWentWrong(null);
  }
}

extension MapApiExtension<K, V> on Map<K, V> {
  Map<K, V> toNotHaveNull() {
    removeWhere((key, value) => value == null);
    return this;
  }
}

extension MapString on Map<String, dynamic> {
  Map<String, String> convertToQueryMap() {
    Map<String, String> formattedParams = map((key, value) {
      if (value is List) {
        return MapEntry(key, value.map((e) => e.toString()).join(','));
      }
      return MapEntry(key, value.toString());
    });
    return formattedParams;
  }
}

extension ViewStateSwitch<T> on ViewState<T> {
  R switchCase<R>({
    required R Function(Success<T> state) success,
    required R Function(Failed<T> state) failed,
    required R Function() empty,
    required R Function() noInternet,
    required R Function() timeout,
    required R Function(SomethingWentWrong<T> state) somethingWentWrong,
    required R Function() nothing,
  }) {
    if (this is Success<T>) {
      return success(this as Success<T>);
    } else if (this is Failed<T>) {
      return failed(this as Failed<T>);
    } else if (this is Empty<T>) {
      return empty();
    } else if (this is NoInternet<T>) {
      return noInternet();
    } else if (this is Timeout<T>) {
      return timeout();
    } else if (this is SomethingWentWrong<T>) {
      return somethingWentWrong(this as SomethingWentWrong<T>);
    } else if (this is Nothing<T>) {
      return nothing();
    } else {
      FirebaseCrashlytics.instance.recordError(this, null, fatal: false);
      throw UnimplementedError('Unhandled ViewState: $this');
    }
  }
}

extension FilterSuccess<T> on Future<ViewState<T>> {
  Future<ViewState<R>> filterSuccess<R>(
      Future<ViewState<R>> Function(T data) onNext) async {
    final result = await this;
    if (result is Success<T>) {
      final data = result.data;
      return await onNext.call(data);
    } else {
      return result.toNotSuccess();
    }
  }
}

extension ListValidation<T> on List<T> {
  ViewState<List<T>> toViewStateOfList() {
    if (isEmpty) {
      return Empty();
    } else {
      return Success(this);
    }
  }
}

extension DialogValidation<T> on ViewState<T> {
  void validateWithDialog(Function(T data) onNext) {
    if (this is Success<T>) {
      final data = (this as Success<T>).data;
      onNext.call(data);
    } else {
      final message = toMessage();
      AppDialog.show(
        title: "Information",
        message: message,
        titlePositive: "Okay",
      );
    }
  }

  void validateWithRetryDialog(
      {required Function(T data) onNext,
      Function()? onError,
      required Function() onRetry}) {
    if (this is Success<T>) {
      final data = (this as Success<T>).data;
      onNext.call(data);
    } else {
      onError?.call();
      final message = toMessage();
      AppDialog.show(
        title: "Information",
        message: message,
        titlePositive: "Try Again",
        positiveCallback: onRetry,
        titleNegative: null,
      );
    }
  }
}

class _HttpStatusCode {
  _HttpStatusCode(this.code);

  final int? code;

  static const int continue_ = 100;
  static const int switchingProtocols = 101;
  static const int processing = 102;
  static const int earlyHints = 103;
  static const int ok = 200;
  static const int created = 201;
  static const int accepted = 202;
  static const int nonAuthoritativeInformation = 203;
  static const int noContent = 204;
  static const int resetContent = 205;
  static const int partialContent = 206;
  static const int multiStatus = 207;
  static const int alreadyReported = 208;
  static const int imUsed = 226;
  static const int multipleChoices = 300;
  static const int movedPermanently = 301;
  static const int found = 302;
  static const int movedTemporarily = 302; // Common alias for found.
  static const int seeOther = 303;
  static const int notModified = 304;
  static const int useProxy = 305;
  static const int switchProxy = 306;
  static const int temporaryRedirect = 307;
  static const int permanentRedirect = 308;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int paymentRequired = 402;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int notAcceptable = 406;
  static const int proxyAuthenticationRequired = 407;
  static const int requestTimeout = 408;
  static const int conflict = 409;
  static const int gone = 410;
  static const int lengthRequired = 411;
  static const int preconditionFailed = 412;
  static const int requestEntityTooLarge = 413;
  static const int requestUriTooLong = 414;
  static const int unsupportedMediaType = 415;
  static const int requestedRangeNotSatisfiable = 416;
  static const int expectationFailed = 417;
  static const int imATeapot = 418;
  static const int misdirectedRequest = 421;
  static const int unprocessableEntity = 422;
  static const int locked = 423;
  static const int failedDependency = 424;
  static const int tooEarly = 425;
  static const int upgradeRequired = 426;
  static const int preconditionRequired = 428;
  static const int tooManyRequests = 429;
  static const int requestHeaderFieldsTooLarge = 431;
  static const int connectionClosedWithoutResponse = 444;
  static const int unavailableForLegalReasons = 451;
  static const int clientClosedRequest = 499;
  static const int internalServerError = 500;
  static const int notImplemented = 501;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
  static const int httpVersionNotSupported = 505;
  static const int variantAlsoNegotiates = 506;
  static const int insufficientStorage = 507;
  static const int loopDetected = 508;
  static const int notExtended = 510;
  static const int networkAuthenticationRequired = 511;
  static const int networkConnectTimeoutError = 599;

  bool get connectionError => code == null;

  bool get isUnauthorized => code == unauthorized;

  bool get isForbidden => code == forbidden;

  bool get isNotFound => code == notFound;

  bool get isServerError =>
      between(internalServerError, networkConnectTimeoutError);

  bool between(int begin, int end) {
    return !connectionError && code! >= begin && code! <= end;
  }

  bool get isOk => between(200, 299);

  bool get hasError => !isOk;
}
