// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dartz/dartz.dart';
// ignore: depend_on_referenced_packages
import 'package:file/local.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/file.dart' as cmf;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pokemon_go/controller/pokemon_list_provider.dart';
import 'package:pokemon_go/domain/failure.dart';
import 'package:pokemon_go/domain/pokemon/model/pokemon_shallow.dart';
import 'package:pokemon_go/domain/pokemon/repository.dart';
import 'package:pokemon_go/infrastructure/cache_manager.dart';
import 'package:pokemon_go/main.dart';
import 'package:pokemon_go/presentation/widget/error_header.dart';

import 'widget_test.mocks.dart';

class TestCacheManager extends CacheManager {
  static const fileSystem = f.LocalFileSystem();
  static final file = fileSystem.file('assets/pokeball.png');
  final info = FileInfo(
    file,
    FileSource.Cache,
    DateTime(2050),
    'url',
  );
  TestCacheManager() : super(Config('cacheKey'));

  @override
  Future<void> dispose() async {}

  @override
  Future<FileInfo> downloadFile(
    String url, {
    String? key,
    Map<String, String>? authHeaders,
    bool force = false,
  }) async {
    return info;
  }

  @override
  Future<void> emptyCache() async {}

  @override
  Stream<FileInfo> getFile(
    String url, {
    String? key = '',
    Map<String, String>? headers = const {},
  }) async* {
    yield info;
  }

  @override
  Future<FileInfo?> getFileFromCache(
    String key, {
    bool ignoreMemCache = false,
  }) async {
    return info;
  }

  @override
  Future<FileInfo?> getFileFromMemory(String key) async {
    return info;
  }

  @override
  Stream<FileResponse> getFileStream(
    String url, {
    String? key,
    Map<String, String>? headers,
    bool withProgress = true,
  }) async* {
    yield info;
  }

  @override
  Future<cmf.File> getSingleFile(
    String url, {
    String? key = '',
    Map<String, String>? headers = const {},
  }) async {
    return file;
  }

  @override
  Future<cmf.File> putFile(
    String url,
    Uint8List fileBytes, {
    String? key,
    String? eTag,
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'file',
  }) async {
    return file;
  }

  @override
  Future<cmf.File> putFileStream(
    String url,
    Stream<List<int>> source, {
    String? key,
    String? eTag,
    Duration maxAge = const Duration(days: 30),
    String fileExtension = 'file',
  }) async {
    return file;
  }

  @override
  Future<void> removeFile(String key) async {}
}

@GenerateMocks([PokemonRepository])
void main() async {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('Test GameApp Home', () {
    late final MockPokemonRepository repository;

    setUpAll(() async {
      await loadAppFonts();
      repository = MockPokemonRepository();
    });

    testWidgets(
      'Test Home list',
      (WidgetTester tester) async {
        debugDisableShadows = false;
        tester.view.devicePixelRatio = 3;
        tester.view.physicalSize = const Size(1170, 2532);
        final container = ProviderContainer(
          overrides: [
            cacheManagerProvider(cacheKey: 'Pokemon').overrideWith(
              (provider) => TestCacheManager(),
            ),
            pokemonRepositoryProvider.overrideWith((ref) => repository),
          ],
        );

        when(repository.getPage(
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        )).thenAnswer(
          (Invocation invocation) => Future.delayed(
            const Duration(seconds: 4),
            () => right(
              List.generate(
                invocation.namedArguments[#limit],
                (index) => PokemonShallow(name: 'name$index', id: index),
              ),
            ),
          ),
        );

        await tester.pumpWidget(UncontrolledProviderScope(
          container: container,
          child: const PokemonGoApp(),
        ));

        expect(find.byType(SpinKitDoubleBounce), findsOneWidget);
        expect(
          container.read(pokemonPageProvider),
          const AsyncValue<List<PokemonShallow>>.loading(),
        );
        await tester.pump(const Duration(seconds: 5));

        verifyNever(repository.getDetail(id: anyNamed('id')));
        verify(repository.getPage(
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        )).called(1);

        expect(
          container.read(pokemonPageProvider),
          isA<AsyncData<List<PokemonShallow>>>(),
        );

        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/widget_home.png'),
        );
        debugDisableShadows = true;
      },
    );

    testWidgets(
      'Test Home Pagination',
      (WidgetTester tester) async {
        debugDisableShadows = false;
        tester.view.devicePixelRatio = 3;
        tester.view.physicalSize = const Size(1170, 2532);
        final container = ProviderContainer(
          overrides: [
            cacheManagerProvider(cacheKey: 'Pokemon').overrideWith(
              (provider) => TestCacheManager(),
            ),
            pokemonRepositoryProvider.overrideWith((ref) => repository),
          ],
        );

        when(repository.getPage(
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        )).thenAnswer(
          (Invocation invocation) => Future.delayed(
            const Duration(seconds: 4),
            () {
              final int offset = invocation.namedArguments[#offset];
              return right(
                List.generate(
                  invocation.namedArguments[#limit],
                  (index) => PokemonShallow(
                    name: 'name${index + offset}',
                    id: index + offset,
                  ),
                ),
              );
            },
          ),
        );

        await tester.pumpWidget(UncontrolledProviderScope(
          container: container,
          child: const PokemonGoApp(),
        ));

        expect(find.byType(SpinKitDoubleBounce), findsOneWidget);
        expect(
          container.read(pokemonPageProvider),
          const AsyncValue<List<PokemonShallow>>.loading(),
        );
        await tester.pump(const Duration(seconds: 5));
        verifyNever(repository.getDetail(id: anyNamed('id')));

        expect(
          container.read(pokemonPageProvider),
          isA<AsyncData<List<PokemonShallow>>>().having(
            (p0) => p0.value,
            'first page',
            hasLength(60),
          ),
        );

        await tester.pumpAndSettle();
        await tester.scrollUntilVisible(
          find.text('#59'),
          400,
          scrollable: find.byType(Scrollable),
          duration: const Duration(milliseconds: 300),
        );
        //await tester.fling(find.text('#40'), const Offset(0, 100), 500);

        await tester.pump();
        expect(
          container.read(pokemonPageProvider),
          isA<AsyncLoading<List<PokemonShallow>>>(),
        );
        await tester.pumpAndSettle(const Duration(seconds: 5));

        verify(repository.getPage(
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        )).called(2);

        expect(
          container.read(pokemonPageProvider),
          isA<AsyncData<List<PokemonShallow>>>().having(
            (p0) => p0.value,
            'second page',
            hasLength(120),
          ),
        );

        await tester.fling(find.text('#59'), const Offset(0, -800), 800);
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/widget_home_scroll.png'),
        );
        debugDisableShadows = true;
      },
    );

    testWidgets(
      'Test Home Netork error',
      (WidgetTester tester) async {
        debugDisableShadows = false;
        tester.view.devicePixelRatio = 3;
        tester.view.physicalSize = const Size(1170, 2532);
        final container = ProviderContainer(
          overrides: [
            cacheManagerProvider(cacheKey: 'Pokemon').overrideWith(
              (provider) => TestCacheManager(),
            ),
            pokemonRepositoryProvider.overrideWith((ref) => repository),
          ],
        );

        when(repository.getPage(
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        )).thenAnswer(
          (_) => Future.delayed(
            const Duration(seconds: 4),
            () => throw const NetworkFailure.server(
              message: 'timeout',
              statusCode: 500,
            ),
          ),
        );

        await tester.pumpWidget(UncontrolledProviderScope(
          container: container,
          child: const PokemonGoApp(),
        ));

        expect(find.byType(SpinKitDoubleBounce), findsOneWidget);
        expect(
          container.read(pokemonPageProvider),
          const AsyncValue<List<PokemonShallow>>.loading(),
        );
        await tester.pump(const Duration(seconds: 5));
        expect(
          container.read(pokemonPageProvider),
          isA<AsyncError<List<PokemonShallow>>>(),
        );

        verify(repository.getPage(
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        )).called(1);

        await tester.pumpAndSettle();
        expect(find.byType(ErrorHeader), findsOneWidget);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/widget_error_home.png'),
        );

        reset(repository);

        when(repository.getPage(
          offset: anyNamed('offset'),
          limit: anyNamed('limit'),
        )).thenAnswer(
          (Invocation invocation) => Future.delayed(
            const Duration(seconds: 4),
            () => right(
              List.generate(
                invocation.namedArguments[#limit],
                (index) => PokemonShallow(name: 'name$index', id: index),
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.refresh_outlined));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        verifyNever(repository.getDetail(id: anyNamed('id')));
        expect(
          container.read(pokemonPageProvider),
          isA<AsyncData<List<PokemonShallow>>>(),
        );

        verify(repository.getPage(
          limit: anyNamed('limit'),
          offset: anyNamed('offset'),
        )).called(1);

        debugDisableShadows = true;
      },
    );
  });
}
