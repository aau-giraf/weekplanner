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
  final VoidCallback? onLongPress;
  final VoidCallback? onChoiceTap;
  final String? imageUrl;
  final String? soundUrl;

  const ActivityListItem({
    super.key,
    required this.activity,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.onLongPress,
    this.onChoiceTap,
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
    final soundUrl = widget.soundUrl;
    final hasSound = soundUrl != null && soundUrl.isNotEmpty;
    final isUnresolvedChoice =
        activity.options.isNotEmpty && activity.selectedOptionIndex == null;

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
              : isUnresolvedChoice
                  ? context.colorScheme.tertiaryContainer
                  : context.girafColors.pendingBackground,
          child: InkWell(
            onTap: isUnresolvedChoice
                ? widget.onChoiceTap
                : hasSound
                    ? _togglePlayback
                    : null,
            onLongPress: widget.onLongPress,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Pictogram — hero element, with choice badge
                  Stack(
                    children: [
                      _ActivityPictogram(
                        imageUrl: widget.imageUrl,
                        hasPictogram: activity.pictogramId != null,
                      ),
                      if (isUnresolvedChoice)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: context.colorScheme.tertiary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.touch_app,
                              size: 16,
                              color: context.colorScheme.onTertiary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Title and time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isUnresolvedChoice
                              ? (activity.title ?? 'Tryk for at vælge')
                              : (activity.title ?? 'Unavngivet aktivitet'),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isUnresolvedChoice
                                    ? context.colorScheme.tertiary
                                    : activity.title != null
                                        ? null
                                        : context.colorScheme.outline,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isUnresolvedChoice) ...[
                          const SizedBox(height: 2),
                          Text(
                            '${activity.options.length} valgmuligheder',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.colorScheme.outline,
                                ),
                          ),
                        ],
                        if (activity.startTime case final start?)
                          if (activity.endTime case final end?) ...[
                            const SizedBox(height: 4),
                            Text(
                              '${formatTimeValue(start)} - ${formatTimeValue(end)}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.colorScheme.outline,
                                  ),
                            ),
                          ],
                      ],
                    ),
                  ),
                  // Completion toggle
                  IconButton(
                    onPressed: widget.onToggleStatus,
                    icon: Icon(
                      activity.isCompleted
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: activity.isCompleted
                          ? context.girafColors.completedIndicator
                          : context.colorScheme.outline,
                      size: 28,
                    ),
                    tooltip: activity.isCompleted ? 'Ikke færdig' : 'Færdig',
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
