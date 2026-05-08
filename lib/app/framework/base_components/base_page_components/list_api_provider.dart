abstract class ListApiProvider<F> {
  Future<void> list({F? filter, int? page, int? size, String? sort});

  // Future<void> presetFilter({required F filter});
}
