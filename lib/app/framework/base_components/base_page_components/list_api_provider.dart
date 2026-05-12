import 'package:work_hu/app/framework/base_components/sort_builder.dart';

abstract class ListApiProvider<F> {
  Future<void> list({F? filter, int? page, int? size, List<String>? sort});

  // Future<void> presetFilter({required F filter});
}
