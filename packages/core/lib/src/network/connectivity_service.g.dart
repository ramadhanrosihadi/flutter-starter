// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Service to monitor network connectivity status.
///
/// Exposes a stream of booleans representing whether the device is online
/// (`true`) or offline (`false`).

@ProviderFor(ConnectivityService)
final connectivityServiceProvider = ConnectivityServiceProvider._();

/// Service to monitor network connectivity status.
///
/// Exposes a stream of booleans representing whether the device is online
/// (`true`) or offline (`false`).
final class ConnectivityServiceProvider
    extends $StreamNotifierProvider<ConnectivityService, bool> {
  /// Service to monitor network connectivity status.
  ///
  /// Exposes a stream of booleans representing whether the device is online
  /// (`true`) or offline (`false`).
  ConnectivityServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'connectivityServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$connectivityServiceHash();

  @$internal
  @override
  ConnectivityService create() => ConnectivityService();
}

String _$connectivityServiceHash() =>
    r'bef90e549adba1dd445ca8d7c4e76cc84fa945b0';

/// Service to monitor network connectivity status.
///
/// Exposes a stream of booleans representing whether the device is online
/// (`true`) or offline (`false`).

abstract class _$ConnectivityService extends $StreamNotifier<bool> {
  Stream<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<bool>, bool>,
        AsyncValue<bool>,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}
