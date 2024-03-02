import 'package:work_hu/api/dio_client.dart';
import 'package:work_hu/app/locator.dart';

abstract class BaseApi {
  final DioClient dioClient = locator<DioClient>();
}