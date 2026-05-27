import 'package:app_variant/features/home/presentation/home_screen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.contains('logo.png')) {
      // Return a valid 1x1 transparent PNG to satisfy the image decoder
      final bytes = Uint8List.fromList([
        137,
        80,
        78,
        71,
        13,
        10,
        26,
        10,
        0,
        0,
        0,
        13,
        73,
        72,
        68,
        82,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        1,
        8,
        6,
        0,
        0,
        0,
        31,
        21,
        196,
        137,
        0,
        0,
        0,
        13,
        73,
        68,
        65,
        84,
        120,
        156,
        99,
        96,
        64,
        5,
        0,
        0,
        14,
        0,
        1,
        10,
        73,
        69,
        117,
        0,
        0,
        0,
        0,
        73,
        69,
        78,
        68,
        174,
        66,
        96,
        130
      ]);
      return ByteData.sublistView(bytes);
    }
    throw FlutterError('Asset not found: $key');
  }
}

void main() {
  testWidgets('shows the variant home placeholder', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: DefaultAssetBundle(
          bundle: FakeAssetBundle(),
          child: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome!'), findsOneWidget);
  });
}
