import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:weekplanner/config/api_config.dart';
import 'package:weekplanner/config/theme.dart';
import 'package:weekplanner/shared/models/activity.dart';

class ActivityListItem extends StatefulWidget {
  final Activity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final String? soundUrl;

  const ActivityListItem({
    super.key,
    required this.activity,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
    this.soundUrl,
  });

  @override
  State<ActivityListItem> createState() => _ActivityListItemState();
}

class _ActivityListItemState extends State<ActivityListItem> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final StreamSubscription _onCompleteSubscription;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _onCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _onCompleteSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    } else {
      final url = widget.soundUrl;
      if (url != null && url.isNotEmpty) {
        await _audioPlayer.play(UrlSource(url));
        setState(() => _isPlaying = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;
    final hasSound = widget.soundUrl != null && widget.soundUrl!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => widget.onEdit(),
              backgroundColor: GirafColors.blue,
              foregroundColor: GirafColors.white,
              icon: Icons.edit,
              label: 'Rediger',
            ),
            SlidableAction(
              onPressed: (_) => widget.onDelete(),
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
                  // Sound playback button
                  if (hasSound)
                    IconButton(
                      onPressed: _togglePlayback,
                      icon: Icon(
                        _isPlaying ? Icons.stop_circle : Icons.volume_up,
                        color: GirafColors.blue,
                      ),
                      tooltip: _isPlaying ? 'Stop' : 'Afspil lyd',
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
