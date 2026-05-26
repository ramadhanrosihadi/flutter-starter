import 'dart:developer';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../../domain/entities/quote_entity.dart';
import '../../domain/repositories/quotes_repository.dart';
import '../datasources/quotes_local_data_source.dart';
import '../datasources/quotes_remote_data_source.dart';

/// Offline-first implementation of [QuotesRepository].
///
/// Strategy:
/// - **Read**: Try remote first → save to local → return local data.
///   Falls back to local-only if the network is unavailable.
/// - **Write**: Always write to local first (optimistic), then sync
///   to the server in the background.
/// - **Sync**: Process all unsynced items (create/update/delete) one
///   by one. Errors on individual items are logged but do not halt
///   the overall sync process.
class QuotesRepositoryImpl implements QuotesRepository {
  const QuotesRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final QuotesRemoteDataSource _remoteDataSource;
  final QuotesLocalDataSource _localDataSource;

  @override
  Future<List<QuoteEntity>> getQuotes() async {
    try {
      // Try to fetch fresh data from the server
      final remoteQuotes = await _remoteDataSource.fetchAll();

      // Convert to companions and replace synced data in local DB
      final companions = remoteQuotes.map((q) {
        return q.toDatabaseCompanion();
      }).toList();
      await _localDataSource.replaceAllWithServerData(companions);
    } on DioException catch (e) {
      // Network or server error — fall back to local data silently
      log(
        'QuotesRepository.getQuotes: remote fetch failed, '
        'falling back to local data',
        error: e,
        name: 'QuotesRepository',
      );
    } catch (e) {
      log(
        'QuotesRepository.getQuotes: unexpected error during remote fetch',
        error: e,
        name: 'QuotesRepository',
      );
    }

    // Always return data from local database (single source of truth)
    return _localDataSource.getAllQuotes();
  }

  @override
  Future<QuoteEntity> createQuote({
    required String text,
    required String author,
    String? source,
    bool isActive = true,
  }) async {
    final companion = QuotesCompanion(
      content: Value(text),
      author: Value(author),
      source: Value(source),
      isActive: Value(isActive),
      isSynced: const Value(false),
      syncAction: const Value('create'),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    final localId = await _localDataSource.insertQuote(companion);

    return QuoteEntity(
      localId: localId,
      text: text,
      author: author,
      source: source,
      isActive: isActive,
      isSynced: false,
      syncAction: 'create',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<QuoteEntity> updateQuote({
    required int localId,
    String? text,
    String? author,
    String? source,
    bool? isActive,
  }) async {
    final companion = QuotesCompanion(
      content: text != null ? Value(text) : const Value.absent(),
      author: author != null ? Value(author) : const Value.absent(),
      source: source != null ? Value(source) : const Value.absent(),
      isActive: isActive != null ? Value(isActive) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await _localDataSource.updateQuote(localId, companion);

    // Return updated data from local DB
    final allQuotes = await _localDataSource.getAllQuotes();
    return allQuotes.firstWhere((q) => q.localId == localId);
  }

  @override
  Future<void> deleteQuote(int localId) async {
    await _localDataSource.markAsDeleted(localId);
  }

  @override
  Future<void> syncQuotes() async {
    // Check server availability first
    final isOnline = await _remoteDataSource.checkHealth();
    if (!isOnline) {
      log(
        'QuotesRepository.syncQuotes: server unreachable, skipping sync',
        name: 'QuotesRepository',
      );
      return;
    }

    // Get all unsynced items
    final unsyncedQuotes = await _localDataSource.getUnsyncedQuotes();

    for (final quote in unsyncedQuotes) {
      try {
        switch (quote.syncAction) {
          case 'create':
            final created = await _remoteDataSource.create(
              text: quote.text,
              author: quote.author,
              source: quote.source,
              isActive: quote.isActive,
            );
            await _localDataSource.markAsSynced(
              quote.localId,
              serverId: created.id,
            );

          case 'update':
            if (quote.id == null) {
              log(
                'QuotesRepository.syncQuotes: cannot update quote '
                'localId=${quote.localId} — no server ID',
                name: 'QuotesRepository',
              );
              continue;
            }
            await _remoteDataSource.update(
              id: quote.id!,
              text: quote.text,
              author: quote.author,
              source: quote.source,
              isActive: quote.isActive,
            );
            await _localDataSource.markAsSynced(quote.localId);

          case 'delete':
            if (quote.id == null) {
              // No server ID — just delete locally
              await _localDataSource.deletePermanently(quote.localId);
              continue;
            }
            await _remoteDataSource.delete(quote.id!);
            await _localDataSource.deletePermanently(quote.localId);

          default:
            log(
              'QuotesRepository.syncQuotes: unknown syncAction '
              '"${quote.syncAction}" for localId=${quote.localId}',
              name: 'QuotesRepository',
            );
        }
      } catch (e) {
        // Log but don't rethrow — continue syncing remaining items
        log(
          'QuotesRepository.syncQuotes: failed to sync '
          'localId=${quote.localId} (action=${quote.syncAction})',
          error: e,
          name: 'QuotesRepository',
        );
      }
    }

    // After syncing all pending items, refresh local data from server
    try {
      final remoteQuotes = await _remoteDataSource.fetchAll();
      final companions = remoteQuotes.map((q) => q.toDatabaseCompanion()).toList();
      await _localDataSource.replaceAllWithServerData(companions);
    } catch (e) {
      log(
        'QuotesRepository.syncQuotes: failed to refresh from server after sync',
        error: e,
        name: 'QuotesRepository',
      );
    }
  }
}
