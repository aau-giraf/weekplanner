import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/organisation_picker/domain/organisation_picker_state.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
import 'package:weekplanner/shared/models/organisation.dart';

/// Screen that lists the user's organisations.
class OrganisationPickerView extends StatelessWidget {
  const OrganisationPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organisationer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
      body: BlocBuilder<OrganisationPickerCubit, OrganisationPickerState>(
        builder: (context, state) => switch (state) {
          OrganisationPickerInitial() ||
          OrganisationsLoading() =>
            const Center(child: CircularProgressIndicator()),
          OrganisationPickerError(:final message, :final organisations)
              when organisations.isEmpty =>
            _ErrorWithRetry(message: message),
          OrganisationsLoaded(organisations: final orgs) when orgs.isEmpty =>
            const Center(child: Text('Ingen organisationer fundet')),
          OrganisationsLoaded(:final organisations) =>
            _OrganisationList(organisations: organisations),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _ErrorWithRetry extends StatelessWidget {
  final String message;

  const _ErrorWithRetry({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(color: context.colorScheme.error),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                context.read<OrganisationPickerCubit>().loadOrganisations(),
            child: const Text('Prøv igen'),
          ),
        ],
      ),
    );
  }
}

class _OrganisationList extends StatelessWidget {
  final List<Organisation> organisations;

  const _OrganisationList({required this.organisations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: organisations.length,
      itemBuilder: (context, index) {
        final org = organisations[index];
        return _OrgCard(org: org);
      },
    );
  }
}

class _OrgCard extends StatelessWidget {
  final Organisation org;

  const _OrgCard({required this.org});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: context.colorScheme.primary,
          child: Text(
            org.name.isNotEmpty ? org.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(org.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/organisations/${org.id}/citizens'),
      ),
    );
  }
}
