import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/localization.dart';
import 'package:work_hu/app/framework/base_components/base_api.dart';
import 'package:work_hu/app/framework/base_components/base_page_components/base_state.dart';
import 'package:work_hu/app/models/mode_state.dart';
import 'package:work_hu/app/providers/router_provider.dart';

import '../widgets/loading_screen.dart';

abstract class BaseDataNotifier<S> extends StateNotifier<S> {
  BaseDataNotifier(super.initState);

  S copyWithState(BaseState status);

  copyWithModelState(ModelState modelState) {
    return copyWithState(BaseState(modelState: modelState));
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

      final response = await apiCall();
      LoadingScreen.instance().hide();

      if (response != null) {
        state = copyWithModelState(ModelState.success);
        await onSuccess?.call(response as T);
        return response;
      } else {
        final errorMessage = response?.message ?? 'api_unknown_error'.i18n();

        if (onError != null) {
          state = copyWithModelState(ModelState.empty);
          await onError.call(errorMessage);
        } else {
          state = copyWithState(BaseState(modelState: ModelState.error, message: errorMessage));
        }
        return null;
      }
    } on DioException catch (e) {
      LoadingScreen.instance().hide();
      final dioErrorMsg = e.message ?? 'api_unknown_error'.i18n();

      if (onError != null) {
        state = copyWithModelState(ModelState.empty);
        await onError.call(dioErrorMsg);
      } else {
        state = copyWithState(BaseState(modelState: ModelState.error, message: "api_unknown_error".i18n()));
      }
      return null;
    } catch (genericError) {
      LoadingScreen.instance().hide();
      if (onError != null) {
        state = copyWithModelState(ModelState.empty);
        await onError.call(genericError.toString());
      } else {
        state = copyWithState(BaseState(modelState: ModelState.error, message: "api_unknown_error".i18n()));
      }
      return null;
    }
  }
}
