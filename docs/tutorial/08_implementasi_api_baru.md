# 🌐 Modul 8: Langkah-Demi-Langkah Mengimplementasikan API Baru

Salah satu pertanyaan terbesar bagi programmer pemula saat menggunakan arsitektur Clean Architecture adalah: **"Bagaimana cara mengimplementasikan satu API baru secara lengkap dari awal?"**

Jika kita hanya melihat potongan kode saja, aliran arsitektur ini akan terasa membingungkan. Di modul ini, kita akan melakukan simulasi praktis langkah-demi-langkah menambahkan fitur API baru: **"Get Weather / Mengambil Data Cuaca"** secara utuh dari Domain hingga Presentation!

---

## 🏗️ Peta Folder Studi Kasus (Fitur Weather)

Ketika kita ingin membuat fitur baru bernama `weather`, strukturnya di dalam package `features_shared` akan seperti ini:

```text
features_shared/lib/src/weather/
├── domain/
│   ├── entities/
│   │   └── weather.dart             # 1. Objek data bisnis murni
│   ├── repositories/
│   │   └── weather_repository.dart  # 2. Kontrak (Interface) Repository
│   └── usecases/
│       └── get_weather_usecase.dart # 6. Logika bisnis UseCase
├── data/
│   ├── models/
│   │   └── weather_model.dart       # 3. Model serialisasi JSON API
│   ├── datasources/
│   │   └── weather_remote_ds.dart   # 4. Request API dengan Dio
│   └── repositories/
│       └── weather_repo_impl.dart   # 5. Realisasi nyata kontrak repository
└── presentation/
    ├── weather_notifier.dart        # 7. Riverpod State Notifier
    └── weather_screen.dart          # 8. Widget UI Tampilan
```

Mari kita bangun satu per satu berkas di atas!

---

## Langkah 1: Mendefinisikan Entity (Domain Layer)
Lokasi: `domain/entities/weather.dart`

Entity adalah kelas Dart murni yang merepresentasikan data bisnis murni. Bagian ini bebas dari library eksternal Flutter atau HTTP.

```dart
// domain/entities/weather.dart
class Weather {
  const Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
  });

  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
}
```

---

## Langkah 2: Membuat Kontrak Repository (Domain Layer)
Lokasi: `domain/repositories/weather_repository.dart`

Kontrak berupa `abstract class` yang mendefinisikan apa saja fungsi yang wajib disediakan untuk mengambil data cuaca, tanpa memedulikan detail teknis (apakah lewat REST API, GraphQL, atau database lokal).

```dart
// domain/repositories/weather_repository.dart
import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(String city);
}
```

---

## Langkah 3: Membuat Model DTO (Data Layer)
Lokasi: `data/models/weather_model.dart`

Model bertugas menjembatani format JSON mentah dari API backend dengan Entity murni di Domain Layer. Model mewarisi (*extends*) atau mengimplementasikan Entity.

```dart
// data/models/weather_model.dart
import '../../domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.cityName,
    required super.temperature,
    required super.condition,
    required super.humidity,
  });

  /// Mengubah JSON Map dari API server menjadi objek WeatherModel
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['city_name'] as String? ?? '',
      // Menjaga agar parsing double aman dari int
      temperature: (json['temperature'] as num? ?? 0.0).toDouble(),
      condition: json['condition'] as String? ?? 'Clear',
      humidity: json['humidity'] as int? ?? 0,
    );
  }

  /// Mengonversi objek ke JSON jika ingin mengirim data ke server
  Map<String, dynamic> toJson() {
    return {
      'city_name': cityName,
      'temperature': temperature,
      'condition': condition,
      'humidity': humidity,
    };
  }
}
```

---

## Langkah 4: Menghubungkan API dengan Dio (Data Layer)
Lokasi: `data/datasources/weather_remote_ds.dart`

Di sinilah REST API dipanggil menggunakan Dio client bawaan proyek. Kita tidak melakukan penanganan error yang kompleks di sini; biarkan interceptor Dio global di `core` menangani logging, otorisasi token, dan mapping HTTP Exception.

```dart
// data/datasources/weather_remote_ds.dart
import 'package:dio/dio.dart';
import '../models/weather_model.dart';

class WeatherRemoteDataSource {
  const WeatherRemoteDataSource(this._dio);

  final Dio _dio;

  /// Memanggil endpoint: GET /v1/weather?city={city}
  Future<WeatherModel> fetchWeather(String city) async {
    final response = await _dio.get(
      'v1/weather',
      queryParameters: {'city': city},
    );
    
    // Asumsi bentuk response: { "success": true, "data": { "city_name": "...", ... } }
    final jsonMap = response.data['data'] as Map<String, dynamic>;
    return WeatherModel.fromJson(jsonMap);
  }
}
```

---

## Langkah 5: Mengimplementasikan Repository Contract (Data Layer)
Lokasi: `data/repositories/weather_repo_impl.dart`

Di layer ini, kita merealisasikan kontrak abstract class `WeatherRepository` yang telah dibuat di Domain Layer. Repository Impl bertugas memanggil Remote DataSource, melakukan konversi model ke entity, dan mengelola cache jika diperlukan.

```dart
// data/repositories/weather_repo_impl.dart
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_ds.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  const WeatherRepositoryImpl(this._remoteDataSource);

  final WeatherRemoteDataSource _remoteDataSource;

  @override
  Future<Weather> getWeather(String city) async {
    // Memanggil API remote, mengembalikan Weather (karena WeatherModel extends Weather)
    return await _remoteDataSource.fetchWeather(city);
  }
}
```

---

## Langkah 6: Membuat UseCase (Domain Layer)
Lokasi: `domain/usecases/get_weather_usecase.dart`

UseCase mengonsumsi Repository murni untuk mengeksekusi satu aksi bisnis yang spesifik. Gunakan *callable class* `call()` agar UseCase bisa dipanggil seperti fungsi biasa.

```dart
// domain/usecases/get_weather_usecase.dart
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeatherUseCase {
  const GetWeatherUseCase(this._repository);

  final WeatherRepository _repository;

  Future<Weather> call(String city) async {
    // Melakukan validasi tambahan jika perlu (misal: nama kota tidak boleh kosong)
    if (city.trim().isEmpty) {
      throw Exception('Nama kota tidak boleh kosong!');
    }
    return await _repository.getWeather(city);
  }
}
```

---

## Langkah 7: Menyusun State & Notifier (Presentation Layer)
Lokasi: `presentation/weather_notifier.dart`

Di sini kita mendaftarkan Dependency Injection (DI) untuk DataSource, Repository, UseCase, serta membuat Notifier State menggunakan kekuatan **Riverpod Generator**.

### Bagian A: Mendaftarkan DI via Provider Generator
```dart
// presentation/weather_providers.dart (atau digabung di notifier)
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/weather_remote_ds.dart';
import '../data/repositories/weather_repo_impl.dart';
import '../domain/repositories/weather_repository.dart';
import '../domain/usecases/get_weather_usecase.dart';

part 'weather_providers.g.dart'; // Akan di-generate otomatis

@riverpod
WeatherRemoteDataSource weatherRemoteDS(Ref ref) {
  // Mengambil instance Dio global dari core package
  final dio = ref.watch(dioClientProvider).dio;
  return WeatherRemoteDataSource(dio);
}

@riverpod
WeatherRepository weatherRepository(Ref ref) {
  final remoteDS = ref.watch(weatherRemoteDSProvider);
  return WeatherRepositoryImpl(remoteDS);
}

@riverpod
GetWeatherUseCase getWeatherUseCase(Ref ref) {
  final repository = ref.watch(weatherRepositoryProvider);
  return GetWeatherUseCase(repository);
}
```

### Bagian B: Membuat Notifier Menggunakan Riverpod `@riverpod`
```dart
// presentation/weather_notifier.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities/weather.dart';
import 'weather_providers.dart';

part 'weather_notifier.g.dart'; // Akan di-generate otomatis

@riverpod
class WeatherNotifier extends _$WeatherNotifier {
  @override
  AsyncValue<Weather?> build() {
    // Nilai awal: Belum ada data cuaca yang dicari
    return const AsyncValue.data(null);
  }

  Future<void> fetchWeather(String city) async {
    state = const AsyncLoading();
    
    // AsyncValue.guard menangani try-catch otomatis dan memetakan error ke UI
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getWeatherUseCaseProvider);
      return await useCase(city);
    });
  }
}
```

*Jangan lupa jalankan perintah generator:*
```bash
dart run melos run codegen
```

---

## Langkah 8: Barrel Export (Menghubungkan ke Pintu Utama)
Lokasi: `packages/features_shared/lib/features_shared.dart`

Daftarkan berkas layar UI dan Notifier Anda di file barrel utama agar aplikasi utama (`apps/main`) bisa mengimpornya dengan satu baris rapi.

```dart
// Tambahkan baris ekspor berikut di features_shared.dart
export 'src/weather/presentation/weather_notifier.dart';
export 'src/weather/presentation/weather_screen.dart';
```

---

## Langkah 9: Memanggil di Tampilan UI (Presentation Layer)
Lokasi: `presentation/weather_screen.dart`

Gunakan `ConsumerWidget` untuk mengonsumsi state dan me-rebuild UI secara responsif.

```dart
// presentation/weather_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'weather_notifier.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 1. Memantau state cuaca saat ini (Loading/Error/Data)
    final weatherState = ref.watch(weatherNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Search')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Masukkan Nama Kota'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 2. Memicu aksi pencarian cuaca
                ref.read(weatherNotifierProvider.notifier).fetchWeather(_cityController.text);
              },
              child: const Text('Cari Cuaca'),
            ),
            const SizedBox(height: 32),
            
            // 3. Menampilkan status UI berdasarkan State
            weatherState.when(
              data: (weather) {
                if (weather == null) {
                  return const Text('Silakan cari kota terlebih dahulu.');
                }
                return Column(
                  children: [
                    Text(weather.cityName, style: theme.textTheme.headlineMedium),
                    Text('${weather.temperature}°C', style: theme.textTheme.headlineLarge),
                    Text(weather.condition, style: theme.textTheme.titleMedium),
                    Text('Kelembaban: ${weather.humidity}%'),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text(
                'Terjadi Kesalahan: $err',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Kesimpulan Aliran Implementasi API

Setiap kali Anda diminta menambahkan API baru di masa depan, ikuti **9 Langkah Emas** ini secara berurutan. Ini adalah standar baku industri untuk pengembangan aplikasi berskala besar. Kode Anda akan selalu terstruktur, modular, sangat mudah diuji (*highly testable*), dan bebas dari *spaghetti code*!

👉 **[Kembali ke Modul 0: Peta Belajar](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/00_overview.md)**

Bila Anda ingin langsung mempraktikkan konsep 9 Langkah Emas ini pada studi kasus nyata berskala penuh (menyinkronkan state, caching database Drift lokal, dan memanggil server REST API secara riil), ikuti modul praktek di bawah ini:

👉 **[Praktek Nyata: Tutorial Membuat Fitur Quotes (Clean Architecture & Drift Caching)](file:///c:/Users/62822/Documents/Work/flutter/flutter-starter/docs/tutorial/usecases/usecase_manage_quotes/uc_manage_quotes.md)**
