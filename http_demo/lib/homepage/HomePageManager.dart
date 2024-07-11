import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HomePageManager {
  final resultNotifier = ValueNotifier<RequestState>(RequestInitial());
  static const urlPrefix = 'https://jsonplaceholder.typicode.com';

  void Function(String message)? onError;
  Future<void> trySomething() async {
    await Future.delayed(const Duration(milliseconds: 200));
    onError?.call('Sorry, there was an error.');
  }

  Future<void> makeGetRequest() async {
    resultNotifier.value = RequestLoadInProgress();
    final url = Uri.parse('$urlPrefix/posts');
    Response response = await get(url);
    print('Status code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    _handleResponse(response);
  }

  Future<void> makePostRequest() async {
    resultNotifier.value = RequestLoadInProgress();
    final url = Uri.parse('$urlPrefix/posts');
    final headers = {"Content-Type": "application/json"};
    final json = '{"title": "Hello", "body": "body text", "userId": 1}';
    final response = await post(url, headers: headers, body: json);
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    _handleResponse(response);
  }

  Future<void> makePutRequest() async {
    resultNotifier.value = RequestLoadInProgress();
    final url = Uri.parse('$urlPrefix/posts');
    final headers = {"Content-type": "application/json"};
    final json = '{"title": "Hello", "body": "body text", "userId": 1}';
    final response = await put(url, headers: headers, body: json);
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    _handleResponse(response);
  }

  Future<void> makePatchReqeust() async {
    resultNotifier.value = RequestLoadInProgress();
    final url = Uri.parse('$urlPrefix/posts/1');
    final headers = {"Conent-type": "application/json"};
    final json = '{"title": "Hello"}';
    final response = await patch(url, headers: headers, body: json);
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    _handleResponse(response);
  }

  Future<void> makeDeleteRequest() async {
    resultNotifier.value = RequestLoadInProgress();
    final url = Uri.parse('$urlPrefix/posts/1');
    final response = await delete(url);
    print('Headers: ${response.headers}');
    print('Body: ${response.body}');
    _handleResponse(response);
  }

  void _handleResponse(Response response) {
    if (response.statusCode >= 400) {
      resultNotifier.value = RequestLoadFailure();
    } else {
      resultNotifier.value = RequestLoadSuccess(response.body);
    }
  }
}

sealed class RequestState {
  const RequestState();
}

class RequestInitial extends RequestState {}

class RequestLoadInProgress extends RequestState {}

class RequestLoadSuccess extends RequestState {
  const RequestLoadSuccess(this.body);
  final String body;
}

class RequestLoadFailure extends RequestState {}
