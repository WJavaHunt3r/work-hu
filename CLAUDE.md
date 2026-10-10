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

**Routing** (`lib/app/providers/router_provider.dart`): a single GoRouter using `StatefulShellRoute.indexedStack` with branches (balance/home, status, jobs, profile, admin; the bottom nav items follow this order), with sub-routes nested under them. `redirect` sends users to `/login` unless the route is public (`/login`, `/tos`, `/privacy`, `/donate…`), and forces `/change-password` when `user.changedPassword` is false. Users without a church (`UserModel.churchId` null, sent by the backend's `UserDto`) only get the balance and profile tabs: `ScaffoldWithNestedNavigation._tabs` hides the rest (bar items carry their branch index, since hidden tabs leave gaps) and `redirect` sends `/`, `/status`, `/jobs` and `/admin…` to `/balance`. The router refreshes on `UserProvider` changes. New pages must be registered here.

**Roles:** `UserModel` (in `features/login/data/model/`) has role helpers such as `isAdmin()`. Providers use them to scope queries (e.g. non-admins are filtered to their own id).

**Roles and permissions:** a user has several roles (`UserModel.roleNames`) and the backend sends the union of their permissions as `UserModel.permissions` (names, so permissions this app doesn't know yet don't break parsing). Check access with `user.hasPermission(Permission.X)` (enum in `lib/app/models/permission.dart`, mirrors the backend), not with `role`. `role` is only the legacy single role the backend derives. Roles are managed in `lib/features/roles/` (admin → Roles, needs `ROLE_MANAGE`; the ADMIN role is read-only, built-in roles can't be renamed or deleted) and assigned to users in `UserDetails` via `PUT /user/{id}/roles`. The admin page and the bottom nav (`UserModel.hasAdminAccess()`) show entries by permission; admins keep seeing everything. The backend stays the authority: the UI only hides what the user couldn't do anyway.

**Jobs (pre-registration):** `lib/features/jobs/`. A job exists before it happens; people register (with a comment), there is a registration and cancellation deadline, an optional participant limit with waitlist, age limits and a gender restriction. Users register themselves, their spouse and (as adults with the same `familyId`) their children; `JOB_MANAGE_ALL` registers anyone, from the Jobs tab as well as the admin list. The responsible user (or `JOB_MANAGE_ALL`) completes the job with hours per registered user, which creates a normal activity that then follows the existing activity flow. Creating jobs needs `JOB_CREATE`. The Jobs tab (`/jobs`, `/jobs/:id`) is for registering, plus "complete" for the job's responsible person; creating, editing, cancelling, completing and registering anyone happen in admin → Jobs (`/admin/jobs`, `create`, `:id`, `:id/edit`, shown with `JOB_CREATE` or `JOB_MANAGE_ALL`). Both use `JobsPage` / `JobDetailPage` with a `manage` flag; `jobsDataProvider` is a family by that flag. Old `/profile/jobs…` links redirect to `/jobs…`. The repository wraps calls in `guardApi` (`lib/app/framework/api_exception.dart`) so the backend's plain-text reason (409 full, 422 deadline passed or not eligible) reaches the user: notifiers pass `onError: (m) => showApiError(m)` to `executeApiCall`.

**Audit log:** `lib/features/audit_log/`, admin → Audit log (needs `AUDIT_LOG_VIEW`, backend `GET /api/auditLog`). Newest first, filters for action, entity type, user, dates and free text; tapping an entry shows its details JSON. Action names are kept as strings and translated with `audit_action_<NAME>` (unknown ones show their raw name).

**Incomplete names:** when Google sends no last name the backend stores `-` and sets `UserModel.profileIncomplete`. `CompleteNameGate` (wrapped around the shell in `router_provider.dart`) then shows a small non-dismissible dialog asking for last and first name and saves it with `PUT /user/{id}`; it also appears for a restored session. The only way out besides saving is logging out.

**Platform look:** the iOS app uses Cupertino widgets, Android and the web (also in an iPhone browser: `dukapp.dart` sets the theme platform to Android on the web) keep Material. `lib/app/platform/adaptive.dart` has the helpers: `useCupertino(context)`, `AdaptiveAlertDialog` (drop-in for `AlertDialog`, turns TextButton/FilledButton actions into Cupertino dialog actions), `pickDate` / `pickTime` (instead of `showDatePicker` / `showTimePicker`) and `AdaptiveSegmented` (instead of `SegmentedButton`). Switches, checkboxes, progress indicators and `RefreshIndicator` use their `.adaptive` constructors, and the bottom navigation is a `CupertinoTabBar` on iOS. New code should use these instead of the plain Material ones. Text fields, buttons and app bars stay Material on every platform.

**i18n:** the `localization` package loads JSON from `lib/I18n/` (`en_US.json`, `hu_HU.json`). Use `"key".i18n()`. Add every new key to both files.

**Sizing:** `flutter_screenutil` uses a 360×640 design size, so use `.w`, `.h`, `.sp`.

**Misc:** `lib/features/utils.dart` has shared helpers (date formatting, secure-storage `saveData`/`getData`, unit labels). Firebase messaging and local notifications are dependencies used for push notifications.
