import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/usecases/get_profile_use_case.dart';
import '../../auth/presentation/auth_provider.dart';

part 'profile_provider.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(ref.watch(authRepositoryProvider));
}

@riverpod
Future<Profile?> profile(Ref ref) {
  ref.watch(authProvider);
  final repo = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repo)();
}
