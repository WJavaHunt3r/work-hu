enum ModelState {
  error,
  loading,
  success,
  empty,

  /// A request that must not block the UI (list paging, reloads). No overlay; pages show inline progress.
  backgroundLoading,

  /// A background request failed. No error dialog; pages show an inline retry.
  backgroundError
}

extension ModelStateExtension on ModelState {
  bool get isError => this == ModelState.error;
  bool get isLoading => this == ModelState.loading;
  bool get isSuccess => this == ModelState.success;
  bool get isBackgroundLoading => this == ModelState.backgroundLoading;
  bool get isBackgroundError => this == ModelState.backgroundError;
  bool get isAnyLoading => isLoading || isBackgroundLoading;
}
