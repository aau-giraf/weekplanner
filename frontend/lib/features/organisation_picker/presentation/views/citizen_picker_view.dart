import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/organisation_picker/domain/organisation_picker_state.dart';
import 'package:weekplanner/features/organisation_picker/presentation/organisation_picker_cubit.dart';
import 'package:weekplanner/shared/models/citizen.dart';
import 'package:weekplanner/shared/models/grade.dart';

/// Screen that lists citizens and grades for a selected organisation.
class CitizenPickerView extends StatelessWidget {
  /// The organisation whose citizens are displayed.
  final int orgId;

  const CitizenPickerView({super.key, required this.orgId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vælg borger'),
      ),
      body: BlocBuilder<OrganisationPickerCubit, OrganisationPickerState>(
        builder: (context, state) => switch (state) {
          CitizensLoading() =>
            const Center(child: CircularProgressIndicator()),
          CitizensLoaded(:final citizens, :final grades) =>
            _CitizenGradeList(
              citizens: citizens,
              grades: grades,
              orgId: orgId,
            ),
          OrganisationPickerError(:final message) =>
            Center(
              child: Text(
                message,
                style: const TextStyle(color: GirafColors.red),
              ),
            ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _CitizenGradeList extends StatelessWidget {
  final List<Citizen> citizens;
  final List<Grade> grades;
  final int orgId;

  const _CitizenGradeList({
    required this.citizens,
    required this.grades,
    required this.orgId,
  });

  @override
  Widget build(BuildContext context) {
    final allItems = <_PickerItem>[
      ...citizens.map((c) => _PickerItem(
            id: c.id,
            name: '${c.firstName} ${c.lastName}',
            isCitizen: true,
          )),
      ...grades.map((g) => _PickerItem(
            id: g.id,
            name: g.name,
            isCitizen: false,
          )),
    ];

    if (allItems.isEmpty) {
      return const Center(child: Text('Ingen borgere eller grupper fundet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  item.isCitizen ? GirafColors.blue : GirafColors.green,
              child: Icon(
                item.isCitizen ? Icons.person : Icons.group,
                color: GirafColors.white,
              ),
            ),
            title: Text(item.name),
            subtitle: Text(item.isCitizen ? 'Borger' : 'Gruppe'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              final type = item.isCitizen ? 'citizen' : 'grade';
              context.go('/weekplan/${item.id}?type=$type&orgId=$orgId');
            },
          ),
        );
      },
    );
  }
}

class _PickerItem {
  final int id;
  final String name;
  final bool isCitizen;

  _PickerItem({required this.id, required this.name, required this.isCitizen});
}
