import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_api.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/router_provider.dart';

import '../widgets/loading_screen.dart';

abstract class BaseDataNotifier<S> extends StateNotifier<S> {
  BaseDataNotifier(super.initState);

  S copyWithStatus(BaseState status);

  copyWithModelState(ModelState modelState) {
    return copyWithStatus(BaseState(modelState: modelState));
  }

  Future<dynamic> executeApiCall<T>(
    Future<dynamic> Function() apiCall, {
    Future<void> Function(T)? onSuccess,
    Future<void> Function(String)? onError,
  }) async {
    try {
      state = copyWithModelState(ModelState.loading);
      Future.microtask(() {
        LoadingScreen.instance().show(context: navigatorKey.currentContext!);
      });
      final response = await apiCall(); // This now returns a specific Result class
      LoadingScreen.instance().hide();
      if (response != null) {
        state = copyWithModelState(ModelState.success);
        await onSuccess?.call(response as T);
        LoadingScreen.instance().hide();
        return response;
      } else {
        state = copyWithStatus(BaseState(modelState: ModelState.error, message: response.message ?? 'api_unknown_error'.i18n()));
        await onError?.call(response.message ?? "");
        return null;
      }
    } catch (e) {
      LoadingScreen.instance().hide();
      state = copyWithStatus(BaseState(modelState: ModelState.error, message: e.toString()));
      await onError?.call(e.toString());
      return null;
    }
  }
}
