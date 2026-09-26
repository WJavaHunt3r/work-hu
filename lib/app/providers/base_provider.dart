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

  /// Runs [apiCall] and tracks its progress in the state's [ModelState].
  ///
  /// With [background] the call does not block the UI: no loading overlay, the state goes to
  /// [ModelState.backgroundLoading], and a failure without [onError] becomes
  /// [ModelState.backgroundError] (shown inline by list pages) instead of an error dialog.
  Future<dynamic> executeApiCall<T>(
    Future<dynamic> Function() apiCall, {
    Future<void> Function(T)? onSuccess,
    Future<void> Function(String)? onError,
    bool background = false,
  }) async {
    var finished = false;
    var overlayShown = false;

    void hideOverlay() {
      finished = true;
      if (overlayShown) {
        overlayShown = false;
        LoadingScreen.instance().hide();
      }
    }

    Future<dynamic> fail(String message) async {
      if (onError != null) {
        state = copyWithModelState(ModelState.empty);
        await onError.call(message);
      } else {
        state = copyWithState(BaseState(
            modelState: background ? ModelState.backgroundError : ModelState.error,
            message: background ? message : "api_unknown_error".i18n()));
      }
      return null;
    }

    try {
      state = copyWithModelState(background ? ModelState.backgroundLoading : ModelState.loading);

      if (!background) {
        // Deferred so it never runs during a build; skipped if the call already finished.
        Future.microtask(() {
          final context = navigatorKey.currentContext;
          if (finished || context == null) return;
          overlayShown = true;
          LoadingScreen.instance().show(context: context);
        });
      }

      final response = await apiCall();
      hideOverlay();

      if (response != null) {
        state = copyWithModelState(ModelState.success);
        await onSuccess?.call(response as T);
        return response;
      }
      return await fail('api_unknown_error'.i18n());
    } on DioException catch (e) {
      hideOverlay();
      return await fail(e.message ?? 'api_unknown_error'.i18n());
    } catch (genericError) {
      hideOverlay();
      return await fail(onError != null ? genericError.toString() : 'api_unknown_error'.i18n());
    }
  }
}
