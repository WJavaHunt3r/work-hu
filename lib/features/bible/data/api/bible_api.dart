import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

class BibleApi {
  final DioClient _dioClient = locator<DioClient>();

  Future<List<dynamic>> getTranslations() async =>
      (await _dioClient.dio.get("/bible/translations")).data as List<dynamic>;

  /// The whole translation as JSON bytes (sent gzipped, unpacked by the HTTP client). Read as a stream: the
  /// client's log interceptor prints every response body, which would be several megabytes of text otherwise.
  Future<Uint8List> getText(String id) async {
    final res = await _dioClient.dio.get<ResponseBody>(
      "/bible/translations/$id",
      options: Options(responseType: ResponseType.stream, receiveTimeout: const Duration(minutes: 3)),
    );
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in res.data!.stream) {
      bytes.add(chunk);
    }
    return bytes.takeBytes();
  }
}
