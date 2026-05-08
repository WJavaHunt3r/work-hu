class SortBuilder {
  final List<String> _sorts = [];

  void add(String property, {bool descending = true}) {
    _sorts.add("$property,${descending ? 'desc' : 'asc'}");
  }

  List<String> build() => _sorts;
}