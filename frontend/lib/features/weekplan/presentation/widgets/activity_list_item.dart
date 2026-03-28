import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

class ActivityListItem extends StatefulWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final String? imageUrl;
  final String? soundUrl;

  const ActivityListItem({
    super.key,
    required this.activity,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.imageUrl,
    this.soundUrl,
  });

  @override
  State<ActivityListItem> createState() => _ActivityListItemState();
}

class _ActivityListItemState extends State<ActivityListItem> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final StreamSubscription _onCompleteSubscription;
  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _onCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      _isPlaying.value = false;
    });
  }

  @override
  void dispose() {
    _onCompleteSubscription.cancel();
    _audioPlayer.dispose();
    _isPlaying.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying.value) {
      await _audioPlayer.stop();
      _isPlaying.value = false;
    } else {
      final url = widget.soundUrl;
      if (url != null && url.isNotEmpty) {
        await _audioPlayer.play(UrlSource(url));
        _isPlaying.value = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    // Null-check on left of && guarantees non-null on right.
    final hasSound = widget.soundUrl != null && widget.soundUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onEdit(),
              backgroundColor: context.girafColors.actionBlue,
              foregroundColor: context.colorScheme.onPrimary,
              icon: Icons.edit,
              label: 'Rediger',
            ),
            SlidableAction(
              onPressed: (_) => widget.onDelete(),
              backgroundColor: context.colorScheme.error,
              foregroundColor: context.colorScheme.onPrimary,
              icon: Icons.delete,
              label: 'Slet',
            ),
          ],
        ),
        child: Card(
          color: activity.isCompleted
              ? context.girafColors.completedBackground
              : context.girafColors.pendingBackground,
          child: InkWell(
            onTap: widget.onToggleStatus,
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
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: widget.imageUrl != null
                          ? Image.network(
                              widget.imageUrl!, // Guarded by != null check above.
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Icon(
                                Icons.image,
                                color: context.colorScheme.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.image,
                              color: context.colorScheme.onPrimary,
                            ),
                    )
                  else
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Icon(
                        Icons.event,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  const SizedBox(width: 12),
                  // Time and title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${formatTimeValue(activity.startTime)} - ${formatTimeValue(activity.endTime)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Sound playback button
                  if (hasSound)
                    ValueListenableBuilder<bool>(
                      valueListenable: _isPlaying,
                      builder: (_, isPlaying, _) => IconButton(
                        onPressed: _togglePlayback,
                        icon: Icon(
                          isPlaying ? Icons.stop_circle : Icons.volume_up,
                          color: context.girafColors.actionBlue,
                        ),
                        tooltip: isPlaying ? 'Stop' : 'Afspil lyd',
                      ),
                    ),
                  // Status indicator
                  Icon(
                    activity.isCompleted
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: activity.isCompleted
                        ? context.girafColors.completedIndicator
                        : context.colorScheme.outline,
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
}
