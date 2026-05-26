import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';

import 'home_provider.dart';
import 'widgets/home_user_header.dart';
import 'widgets/home_menu_grid.dart';
import 'widgets/home_quote_of_the_day.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState is AuthAuthenticated;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              actions: [
                if (!isAuthenticated)
                  TextButton.icon(
                    onPressed: () => context.push('/login'),
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: Text(l10n.login),
                  ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.push(AppRoutes.settings),
                  tooltip: l10n.settings,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: isAuthenticated
                  ? _buildAuthenticatedHeader(context, ref)
                  : _buildGuestHeader(context),
            ),
            const SliverToBoxAdapter(child: HomeQuoteOfTheDay()),
            const SliverToBoxAdapter(child: Divider(height: 24)),
            SliverToBoxAdapter(
              child: HomeMenuGrid(
                onMenuTap: (label) {
                  if (label == 'UI Gallery') {
                    context.push('/ui-gallery');
                  } else if (label == 'Kutipan') {
                    context.push(AppRoutes.quotes);
                  } else if (label == 'Profil') {
                    context.push(AppRoutes.profile);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$label — Fitur belum tersedia')),
                    );
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 32 + MediaQuery.of(context).padding.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedHeader(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    return profileAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(20),
        child: Text('Gagal memuat profil: $e'),
      ),
      data: (profile) => HomeUserHeader(
        profile: profile,
        onEditTap: () => context.push(AppRoutes.editProfile),
        onProfileTap: () => context.push(AppRoutes.profile),
      ),
    );
  }

  Widget _buildGuestHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              size: 28,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcome,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Guest',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
