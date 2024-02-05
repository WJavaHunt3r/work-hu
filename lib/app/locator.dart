import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:work_hu/app/locator.config.dart';

final GetIt locator = GetIt.instance;

@InjectableInit()
Future<void> setupLocator() async {
  locator.init();
}