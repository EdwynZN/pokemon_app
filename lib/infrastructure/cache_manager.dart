import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

part 'cache_manager.g.dart';

@riverpod
CacheManager cacheManager(CacheManagerRef ref, {required String cacheKey}) {
  final cacheManager = CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 400,
    ),
  );

  final link = ref.keepAlive();
  Timer? timer;

  ref
  ..onCancel(() {
      timer?.cancel();
      timer = Timer(const Duration(seconds: 30), link.close);
    })
  ..onDispose(() async {
      timer?.cancel();
      await cacheManager.dispose();
    })
  ..onResume(() {
    timer?.cancel();
  });

  return cacheManager;
}