import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/features/organisation_picker/presentation/view_models/organisation_picker_view_model.dart';

class CitizenPickerView extends StatefulWidget {
  final int orgId;

  const CitizenPickerView({super.key, required this.orgId});

  @override
  State<CitizenPickerView> createState() => _CitizenPickerViewState();
}

class _CitizenPickerViewState extends State<CitizenPickerView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<OrganisationPickerViewModel>();
      // Find org by ID and select it to load citizens/grades
      final org = vm.organisations.firstWhere((o) => o.id == widget.orgId);
      vm.selectOrganisation(org);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vælg borger'),
      ),
      body: Consumer<OrganisationPickerViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(
              child: Text(vm.error!, style: const TextStyle(color: GirafColors.red)),
            );
          }

          final allItems = <_PickerItem>[
            ...vm.citizens.map((c) => _PickerItem(
                  id: c.id,
                  name: '${c.firstName} ${c.lastName}',
                  isCitizen: true,
                )),
            ...vm.grades.map((g) => _PickerItem(
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
                    context.go('/weekplan/${item.id}?type=$type');
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PickerItem {
  final int id;
  final String name;
  final bool isCitizen;

  _PickerItem({required this.id, required this.name, required this.isCitizen});
}
