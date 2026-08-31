import 'package:flutter_cache_manager/flutter_cache_manager.dart';

abstract final class YbImageCache {
  static final manager = CacheManager(
    Config(
      'yordambor_images',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 300,
    ),
  );
}
