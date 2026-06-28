import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/challenge.dart';
import '../../domain/entities/daily_task.dart';
import '../controllers/challenges_controller.dart';
import '../../../../core/widgets/app_empty_state.dart';

class ActiveChallengeScreen extends StatefulWidget {
  const ActiveChallengeScreen({super.key, required this.challengesController});

  final ChallengesController challengesController;

  @override
  State<ActiveChallengeScreen> createState() => _ActiveChallengeScreenState();
}

class _ActiveChallengeScreenState extends State<ActiveChallengeScreen> {
  int _selectedDay = 1;
  bool _showCelebration = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _syncSelectedDay();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToActiveDay();
    });
  }

  @override
  void didUpdateWidget(covariant ActiveChallengeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.challengesController.activeChallenge != widget.challengesController.activeChallenge) {
      _syncSelectedDay();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActiveDay());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToActiveDay() {
    if (_scrollController.hasClients) {
      final active = widget.challengesController.activeChallenge;
      if (active != null) {
        final double targetOffset = (active.currentDay - 1) * 62.0 - 100.0;
        _scrollController.animateTo(
          targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _syncSelectedDay() {
    final active = widget.challengesController.activeChallenge;
    if (active != null) {
      setState(() {
        _selectedDay = active.currentDay;
      });
    }
  }

  void _showVideoModal(BuildContext context, String taskTitle, String videoUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return _SimulatedVideoPlayerDialog(taskTitle: taskTitle, videoUrl: videoUrl);
      },
    );
  }

  Future<void> _completeTask(Challenge active, DailyTask task) async {
    await widget.challengesController.completeDailyTask(
      challengeId: active.id,
      taskId: task.id,
    );

    // If it was the active day, trigger a nice celebration
    if (task.day == active.currentDay) {
      setState(() {
        _showCelebration = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showCelebration = false;
            // Auto advance day if possible
            if (_selectedDay < active.durationDays) {
              _selectedDay += 1;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListenableBuilder(
      listenable: widget.challengesController,
      builder: (context, _) {
        final active = widget.challengesController.activeChallenge;

        if (active == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Active Challenge')),
            body: AppEmptyState(
              icon: Icons.bolt,
              title: 'No Active Challenge',
              description: 'Please browse available challenges and start one to begin tracking.',
              actionLabel: 'Browse Challenges',
              onActionPressed: () => context.go('/challenges'),
            ),
          );
        }

        // Keep day within bounds if lists refreshed
        if (_selectedDay > active.durationDays) {
          _selectedDay = active.durationDays;
        }

        final selectedTask = active.dailyTasks.firstWhere(
          (t) => t.day == _selectedDay,
          orElse: () => active.dailyTasks.first,
        );

        final overallProgress = active.progressPercentage;

        return Scaffold(
          appBar: AppBar(
            title: Text(active.title),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/challenges'),
            ),
          ),
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress header card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: overallProgress,
                              minHeight: 8,
                              backgroundColor: scheme.surfaceContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          '${(overallProgress * 100).toInt()}% Complete',
                          style: theme.textTheme.labelLarge?.copyWith(color: scheme.primary),
                        ),
                      ],
                    ),
                  ),

                  // Horizontal 30-Day Grid/Timeline
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: active.durationDays,
                      itemBuilder: (context, index) {
                        final dayNumber = index + 1;
                        final task = active.dailyTasks[index];
                        final isSelected = dayNumber == _selectedDay;
                        final isCompleted = task.isCompleted;
                        final isCurrentDay = dayNumber == active.currentDay;

                        Color circleColor = scheme.surfaceContainer;
                        Color textColor = scheme.onSurface;
                        Border? border;

                        if (isSelected) {
                          circleColor = scheme.primary;
                          textColor = scheme.onPrimary;
                        } else if (isCompleted) {
                           circleColor = scheme.primaryContainer.withValues(alpha: 0.3);
                          textColor = scheme.primary;
                        } else if (isCurrentDay) {
                          border = Border.all(color: scheme.primary, width: 2);
                        }

                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = dayNumber),
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
                            decoration: BoxDecoration(
                              color: circleColor,
                              shape: BoxShape.circle,
                              border: border,
                            ),
                            alignment: Alignment.center,
                            child: isCompleted && !isSelected

                                ? Icon(Icons.check, color: scheme.primary, size: 18)
                                : Text(
                                    '$dayNumber',
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: isSelected || isCurrentDay
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Selected Day Task card
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Day $_selectedDay Task',
                                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 22),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.timer_outlined, size: 16, color: scheme.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${selectedTask.durationMinutes} min',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectedTask.title,
                            style: theme.textTheme.displayMedium?.copyWith(fontSize: 26),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            selectedTask.description,
                            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 24),

                           // Visual Video Guide Preview (Glassmorphism card)
                          GestureDetector(
                            onTap: () => _showVideoModal(context, selectedTask.title, selectedTask.videoUrl ?? ''),
                            child: Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    scheme.secondary.withValues(alpha: 0.8),
                                    scheme.primary.withValues(alpha: 0.6),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&q=80&w=600',
                                  ),
                                  fit: BoxFit.cover,
                                  opacity: 0.3,
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.play_arrow, color: scheme.secondary, size: 32),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Watch Video Tutorial',
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                          fontSize: 14,
                                          shadows: [
                                            const Shadow(blurRadius: 4, color: Colors.black54),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Complete task action button
                          SizedBox(
                            width: double.infinity,
                            child: selectedTask.isCompleted
                                ? Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: scheme.primaryContainer.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(color: scheme.primary.withValues(alpha: 0.4)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.check_circle, color: scheme.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Task Completed',
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            color: scheme.onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () => _completeTask(active, selectedTask),
                                    icon: const Icon(Icons.check),
                                    label: const Text('Mark as Completed'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Celebration Overlay
              if (_showCelebration)
                Container(
                  color: scheme.shadow.withValues(alpha: 0.6),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
                      const SizedBox(height: 20),
                      Text(
                        'Awesome Work!',
                        style: theme.textTheme.displayMedium?.copyWith(color: scheme.onPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Day $_selectedDay task marked complete.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onPrimary.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SimulatedVideoPlayerDialog extends StatefulWidget {
  const _SimulatedVideoPlayerDialog({required this.taskTitle, required this.videoUrl});
  final String taskTitle;
  final String videoUrl;

  @override
  State<_SimulatedVideoPlayerDialog> createState() => _SimulatedVideoPlayerDialogState();
}

class _SimulatedVideoPlayerDialogState extends State<_SimulatedVideoPlayerDialog> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isPlaying = true;
  double _playbackProgress = 0.0;
  int _elapsedSeconds = 0;
  final int _totalSeconds = 120;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _startPlaybackSimulation();
      }
    });
  }

  void _startPlaybackSimulation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      if (!_isPlaying) return true;

      setState(() {
        if (_elapsedSeconds < _totalSeconds) {
          _elapsedSeconds++;
          _playbackProgress = _elapsedSeconds / _totalSeconds;
        } else {
          _isPlaying = false;
        }
      });
      return _elapsedSeconds < _totalSeconds;
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatDuration(int totalSecs) {
    final mins = totalSecs ~/ 60;
    final secs = totalSecs % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Image.network(
                  'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?auto=format&fit=crop&q=80&w=600',
                  fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.6),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 48,
                child: Text(
                  'Tutorial: ${widget.taskTitle}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              if (_isLoading)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: scheme.primaryContainer),
                    const SizedBox(height: 12),
                    Text(
                      'Loading tutorial video...',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                )
              else ...[
                GestureDetector(
                  onTap: () => setState(() => _isPlaying = !_isPlaying),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                if (_isPlaying)
                  Positioned(
                    bottom: 48,
                    left: 24,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.9, end: 1.1).animate(_pulseController),
                      child: Row(
                        children: [
                          Icon(Icons.volume_up, color: scheme.primaryContainer, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Audio Active',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Text(
                        _formatDuration(_elapsedSeconds),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _playbackProgress,
                          activeColor: scheme.primaryContainer,
                          inactiveColor: Colors.white30,
                          onChanged: (val) {
                            setState(() {
                              _playbackProgress = val;
                              _elapsedSeconds = (val * _totalSeconds).round();
                            });
                          },
                        ),
                      ),
                      Text(
                        _formatDuration(_totalSeconds),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
