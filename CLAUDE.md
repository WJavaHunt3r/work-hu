# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter app (package name `work_hu`, product name "DukApp") for tracking a local PACE/MyShare competition: user status, activities, transactions, payments/donations, top-ups, a "bufe" (kiosk) with SumUp payments, camps, mentors/mentees, and admin tooling. Targets Android, iOS and web (web renders inside a 500px phone-sized frame via `flutter_web_frame`).

## Commands

```bash
flutter pub get
flutter run                     # add -d chrome for web
flutter analyze                 # lints: flutter_lints (see analysis_options.yaml)
dart run build_runner build --delete-conflicting-outputs   # regenerate *.freezed.dart, *.g.dart, locator.config.dart
flutter build apk | flutter build ios | flutter build web
```

There is no `test/` directory yet (`flutter_test` and `mocktail` are available). Single test: `flutter test test/path_test.dart --plain-name "name"`.

Run `build_runner` after changing any `@freezed` / `@JsonSerializable` class or any `@singleton` / `@lazySingleton` / `@injectable` annotation. Never hand-edit generated files.

## Architecture

**Entry:** `lib/main.dart` → `setupLocator()` (get_it + injectable, `lib/app/locator.dart`) → `ProviderScope` → `DukApp` (`lib/dukapp.dart`). `DukApp` waits on `authInitProvider`, then builds `MaterialApp.router` with `routerProvider`, theme and locale providers.

**Two DI systems coexist:**
- **get_it/injectable** for app-wide singletons: HTTP clients in `lib/api/` (`DioClient`, `BufeClient`, `GMClient`) and `UserProvider`. Accessed via `locator<T>()`.
- **Riverpod 3** (mostly the legacy `StateNotifierProvider` API from `flutter_riverpod/legacy.dart`) for feature state. `userDataProvider` wraps the get_it `UserProvider` singleton so the router can listen to it.

**HTTP / auth** (`lib/api/dio_client.dart`): the base URL is hard-coded (`_baseUrl`; a commented LAN alternative sits next to it). A `QueuedInterceptorsWrapper` attaches the JWT and, on 401/403, calls `/auth/refreshtoken`, stores the new tokens (via `Utils.saveData`), and retries; if refresh fails it logs the user out. `main.dart` globally disables TLS certificate validation through `HttpOverrides`.

**Feature layout** (`lib/features/<feature>/`), layered as:
- `data/api/*_api.dart` – raw Dio calls through `locator<DioClient>()`, returns `res.data`
- `data/repository/*_repository.dart` – maps JSON to freezed models, `PaginatedResponse<T>` for lists
- `data/model/` – freezed + json_serializable models; `data/state/` – freezed page state
- `providers/` – declares `xApiProvider` → `xRepoProvider` → `xDataProvider` (a `StateNotifierProvider.autoDispose`)
- `view/` and `widgets/` – UI

Folder names are not fully consistent (`provider` vs `providers`, `widget` vs `widgets`), so check the existing folder before adding files.

**Base framework** (`lib/app/framework/base_components/`, `lib/app/providers/base_provider.dart`):
- Notifiers extend `BaseDataNotifier<S>` and implement `copyWithState(BaseState)`. All API calls go through `executeApiCall<T>(call, onSuccess:, onError:)`, which sets `ModelState` (loading/success/error/empty), shows or hides the global `LoadingScreen` overlay (needs `navigatorKey.currentContext`), and converts errors to i18n messages.
- List screens: the notifier implements `ListApiProvider<F>` (`list({filter, page, size, sort})`), state holds a `BaseListState` (paging info), and the page extends `BaseListPage` / `BaseListPageState<P, S, N>`, which handles infinite scroll paging. Pages that aren't lists extend `BasePage` / `BasePageState`. Build sort params with `SortBuilder`. The paging convention is: page 0 replaces the list, later pages append.
- Shared UI widgets (dialogs, chips, list items, search bar, etc.) live in `lib/app/widgets/`.

**Routing** (`lib/app/providers/router_provider.dart`): a single GoRouter using `StatefulShellRoute.indexedStack` with branches (balance/home, status, profile, admin), with sub-routes nested under them. `redirect` sends users to `/login` unless the route is public (`/login`, `/tos`, `/privacy`, `/donate…`), and forces `/change-password` when `user.changedPassword` is false. The router refreshes on `UserProvider` changes. New pages must be registered here.

**Roles:** `UserModel` (in `features/login/data/model/`) has role helpers such as `isAdmin()`. Providers use them to scope queries (e.g. non-admins are filtered to their own id).

**i18n:** the `localization` package loads JSON from `lib/I18n/` (`en_US.json`, `hu_HU.json`). Use `"key".i18n()`. Add every new key to both files.

**Sizing:** `flutter_screenutil` uses a 360×640 design size, so use `.w`, `.h`, `.sp`.

**Misc:** `lib/features/utils.dart` has shared helpers (date formatting, secure-storage `saveData`/`getData`, unit labels). Firebase messaging and local notifications are dependencies used for push notifications.
