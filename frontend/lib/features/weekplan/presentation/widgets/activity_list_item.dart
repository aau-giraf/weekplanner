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

class _ActivityPictogram extends StatelessWidget {
  final String? imageUrl;
  final bool hasPictogram;

  const _ActivityPictogram({
    required this.imageUrl,
    required this.hasPictogram,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: switch (imageUrl) {
        final url? when hasPictogram => Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Icon(
              Icons.image,
              size: 40,
              color: context.colorScheme.onPrimaryContainer,
            ),
          ),
        _ => Icon(
            hasPictogram ? Icons.image : Icons.event,
            size: 40,
            color: context.colorScheme.onPrimaryContainer,
          ),
      },
    );
  }
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
    final soundUrl = widget.soundUrl;
    final hasSound = soundUrl != null && soundUrl.isNotEmpty;

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
                  // Pictogram — hero element
                  _ActivityPictogram(
                    imageUrl: widget.imageUrl,
                    hasPictogram: activity.pictogramId != null,
                  ),
                  const SizedBox(width: 16),
                  // Title and time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          activity.title ?? 'Unavngivet aktivitet',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: activity.title != null
                                    ? null
                                    : context.colorScheme.outline,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (activity.startTime != null &&
                            activity.endTime != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${formatTimeValue(activity.startTime!)} - ${formatTimeValue(activity.endTime!)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.outline,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Sound + status column
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        activity.isCompleted
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: activity.isCompleted
                            ? context.girafColors.completedIndicator
                            : context.colorScheme.outline,
                        size: 28,
                      ),
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
                    ],
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
