import '../../features/horses/data/models/horse_models.dart';
import '../../features/horses/domain/entities/horse.dart';

abstract final class AppRoutes {
  static const root = '/';
  static const login = '/login';
  static const registry = '/registry';
  static const horseNew = '/registry/new';
  static const rules = '/rules';
  static const client = '/client';

  static const horseIdParam = 'id';
  static const categoryQuery = 'category';
  static const horsePattern = '/registry/:$horseIdParam';
  static const horseEditPattern = '/registry/:$horseIdParam/edit';

  static String horse(int id) => '$registry/$id';
  static String horseEdit(int id) => '$registry/$id/edit';

  static String registryCategory(HorseCategory category) => Uri(
    path: registry,
    queryParameters: {categoryQuery: HorseCodec.encodeCategory(category)},
  ).toString();

  static HorseCategory? parseCategory(String? value) {
    if (value == null) return null;
    try {
      final category = HorseCodec.category(value);
      return HorseCategoryRules.registry.contains(category) ? category : null;
    } on FormatException {
      return null;
    }
  }
}
