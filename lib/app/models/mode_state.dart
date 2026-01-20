enum ModelState{
  error,
  processing,
  success,
  empty
}

extension ModelStateExtension on ModelState {
  bool get isError => this == ModelState.error;
  bool get isProcessing => this == ModelState.processing;
  bool get isSuccess => this == ModelState.success;
}