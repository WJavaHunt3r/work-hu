enum ModelState{
  error,
  loading,
  success,
  empty
}

extension ModelStateExtension on ModelState {
  bool get isError => this == ModelState.error;
  bool get isLoading => this == ModelState.loading;
  bool get isSuccess => this == ModelState.success;
}