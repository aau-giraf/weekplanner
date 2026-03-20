import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/models/activity.dart';

class ActivityListItem extends StatelessWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const ActivityListItem({
    super.key,
    required this.activity,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: GirafColors.blue,
              foregroundColor: GirafColors.white,
              icon: Icons.edit,
              label: 'Rediger',
            ),
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: GirafColors.red,
              foregroundColor: GirafColors.white,
              icon: Icons.delete,
              label: 'Slet',
            ),
          ],
        ),
        child: Card(
          color: activity.isCompleted ? GirafColors.lightGreen : GirafColors.lightBlue,
          child: InkWell(
            onTap: onToggleStatus,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Pictogram
                  if (activity.pictogramId != null)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: GirafColors.orange,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        ApiConfig.pictogramImageUrl(activity.pictogramId!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.image,
                          color: GirafColors.white,
                        ),
                      ),
                    )
                  else
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: GirafColors.orange,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(
                        Icons.event,
                        color: GirafColors.white,
                      ),
                    ),
                  const SizedBox(width: 12),
                  // Time and title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_formatTime(activity.startTime)} - ${_formatTime(activity.endTime)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: GirafColors.gray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status indicator
                  Icon(
                    activity.isCompleted
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: activity.isCompleted
                        ? GirafColors.green
                        : GirafColors.gray,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
    // Time comes as "HH:mm:ss" or "HH:mm", return "HH:mm"
    final parts = time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return time;
  }
}
