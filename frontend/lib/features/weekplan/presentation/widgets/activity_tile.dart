import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/models/activity.dart';
import 'package:weekplanner/shared/utils/date_utils.dart';

/// Pictogram-dominant activity tile for the day view.
///
/// The pictogram fills most of the card. A small label strip at the bottom
/// shows the title and optional time range. Designed for iPad landscape
/// where 6 tiles sit side-by-side in a single row.
class ActivityTile extends StatefulWidget {
  final Activity activity;
  final VoidCallback onToggleStatus;
  final VoidCallback onLongPress;
  final VoidCallback? onChoiceTap;
  final String? imageUrl;
  final String? soundUrl;

  const ActivityTile({
    super.key,
    required this.activity,
    required this.onToggleStatus,
    required this.onLongPress,
    this.onChoiceTap,
    this.imageUrl,
    this.soundUrl,
  });

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
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
    final isUnresolvedChoice =
        activity.options.isNotEmpty && activity.selectedOptionIndex == null;
    final hasSound =
        widget.soundUrl != null && widget.soundUrl!.isNotEmpty;

    final cardColor = activity.isCompleted
        ? context.girafColors.completedBackground
        : isUnresolvedChoice
            ? context.colorScheme.tertiaryContainer
            : context.girafColors.pendingBackground;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: cardColor,
      child: InkWell(
        onTap: isUnresolvedChoice
            ? widget.onChoiceTap
            : hasSound
                ? _togglePlayback
                : null,
        onLongPress: widget.onLongPress,
        child: Column(
          children: [
            Expanded(
              child: _TilePictogram(
                imageUrl: widget.imageUrl,
                hasPictogram: activity.pictogramId != null,
                isCompleted: activity.isCompleted,
                isUnresolvedChoice: isUnresolvedChoice,
                hasSound: hasSound,
                isPlaying: _isPlaying,
              ),
            ),
            _TileLabel(
              activity: activity,
              onToggleStatus: widget.onToggleStatus,
            ),
          ],
        ),
      ),
    );
  }
}

class _TilePictogram extends StatelessWidget {
  final String? imageUrl;
  final bool hasPictogram;
  final bool isCompleted;
  final bool isUnresolvedChoice;
  final bool hasSound;
  final ValueNotifier<bool> isPlaying;

  const _TilePictogram({
    required this.imageUrl,
    required this.hasPictogram,
    required this.isCompleted,
    required this.isUnresolvedChoice,
    required this.hasSound,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Pictogram image or placeholder
        if (imageUrl != null && hasPictogram)
          Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _PictogramPlaceholder(
              icon: Icons.image,
            ),
          )
        else
          _PictogramPlaceholder(
            icon: hasPictogram ? Icons.image : Icons.event,
          ),

        // Completion indicator (top-right)
        if (isCompleted)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: context.girafColors.completedIndicator,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 20,
                color: context.colorScheme.onPrimary,
              ),
            ),
          ),

        // Choice badge (bottom-right)
        if (isUnresolvedChoice)
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
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

        // Sound indicator (top-left)
        if (hasSound)
          Positioned(
            top: 8,
            left: 8,
            child: ValueListenableBuilder<bool>(
              valueListenable: isPlaying,
              builder: (context, playing, _) => Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface.withAlpha(200),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  playing ? Icons.volume_up : Icons.volume_off,
                  size: 16,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PictogramPlaceholder extends StatelessWidget {
  final IconData icon;

  const _PictogramPlaceholder({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.primaryContainer,
      child: Center(
        child: Icon(
          icon,
          size: 48,
          color: context.colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}

class _TileLabel extends StatelessWidget {
  final Activity activity;
  final VoidCallback onToggleStatus;

  const _TileLabel({
    required this.activity,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GirafLayout.tileLabelHeight,
      padding: const EdgeInsets.only(left: 8, right: 2, top: 4, bottom: 4),
      color: context.colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title ?? 'Unavngivet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (activity.startTime case final start?)
                  if (activity.endTime case final end?)
                    Text(
                      '${formatTimeValue(start)} - ${formatTimeValue(end)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.outline,
                          ),
                    ),
              ],
            ),
          ),
          IconButton(
            onPressed: onToggleStatus,
            icon: Icon(
              activity.isCompleted
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: activity.isCompleted
                  ? context.girafColors.completedIndicator
                  : context.colorScheme.outline,
            ),
            tooltip: activity.isCompleted ? 'Ikke færdig' : 'Færdig',
            iconSize: 28,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}
