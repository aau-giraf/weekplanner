import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/auth/presentation/auth_cubit.dart';
import 'package:weekplanner/features/organisation_picker/presentation/view_models/organisation_picker_view_model.dart';
import 'package:weekplanner/shared/models/organisation.dart';

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
      body: Consumer<OrganisationPickerViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading && vm.organisations.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null && vm.organisations.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(vm.error!, style: const TextStyle(color: GirafColors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: vm.loadOrganisations,
                    child: const Text('Prøv igen'),
                  ),
                ],
              ),
            );
          }

          if (vm.organisations.isEmpty) {
            return const Center(
              child: Text('Ingen organisationer fundet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vm.organisations.length,
            itemBuilder: (context, index) {
              final org = vm.organisations[index];
              return _OrgCard(org: org);
            },
          );
        },
      ),
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
          backgroundColor: GirafColors.orange,
          child: Text(
            org.name.isNotEmpty ? org.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: GirafColors.white,
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
