import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/app_settings.dart';
import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_event.dart';
import '../blocs/session/session_state.dart';
import '../blocs/timer/timer_bloc.dart';
import '../blocs/timer/timer_event.dart';
import '../blocs/timer/timer_state.dart';
import '../blocs/display/display_bloc.dart';
import '../blocs/display/display_event.dart';
import '../blocs/display/display_state.dart';
import '../blocs/settings/settings_bloc.dart';
import '../blocs/settings/settings_state.dart';
import '../widgets/sphere_animation_widget.dart';
import '../widgets/aod_clock_widget.dart';
import '../widgets/alarm_overlay_widget.dart';
import '../widgets/timer_status_widget.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Hide system UI for immersive full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Load timers on startup
    context.read<TimerBloc>().add(const LoadTimers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MultiBlocListener(
        listeners: [
          // Session phase -> Display mode
          BlocListener<SessionBloc, SessionState>(
            listenWhen: (prev, curr) => prev.phase != curr.phase,
            listener: (ctx, state) {
              final displayBloc = ctx.read<DisplayBloc>();
              if (state.isActive) {
                displayBloc.add(const EnterActiveMode());
              } else {
                displayBloc.add(const EnterAodMode());
              }
            },
          ),
          // Timer/Alarm fired -> Enter alarm ringing
          BlocListener<TimerBloc, TimerState>(
            listener: (ctx, state) {
              if (state is TimerFiringState || state is AlarmFiringState) {
                ctx.read<DisplayBloc>().add(const EnterAlarmRinging());
              } else if (state is TimerIdle) {
                ctx.read<DisplayBloc>().add(const EnterAodMode());
              }
            },
          ),
        ],
        child: BlocBuilder<DisplayBloc, DisplayState>(
          builder: (context, displayState) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Main content
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  child: displayState.isAod
                      ? const _AodScreen(key: ValueKey('aod'))
                      : const _ActiveScreen(key: ValueKey('active')),
                ),
                // Alarm overlay (on top)
                BlocBuilder<TimerBloc, TimerState>(
                  builder: (ctx, timerState) {
                    if (timerState is TimerFiringState) {
                      return AlarmOverlayWidget(
                        firedTimer: timerState.timer,
                        onDismiss: () {
                          ctx.read<TimerBloc>().add(DismissAlert(timerState.timer.id));
                          ctx.read<DisplayBloc>().add(const EnterAodMode());
                        },
                      );
                    }
                    if (timerState is AlarmFiringState) {
                      return AlarmOverlayWidget(
                        firedAlarm: timerState.alarm,
                        onDismiss: () {
                          ctx.read<TimerBloc>().add(DismissAlert(timerState.alarm.id));
                          ctx.read<DisplayBloc>().add(const EnterAodMode());
                        },
                        onSnooze: () {
                          ctx.read<TimerBloc>().add(DismissAlert(timerState.alarm.id));
                          ctx.read<DisplayBloc>().add(const EnterAodMode());
                          // TODO: Implement snooze via SetTimer use case
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// AOD Mode: full black, drifting clock, tap to reveal settings button
class _AodScreen extends StatefulWidget {
  const _AodScreen({super.key});
  @override
  State<_AodScreen> createState() => _AodScreenState();
}

class _AodScreenState extends State<_AodScreen> {
  bool _showSettingsHint = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showSettingsHint = !_showSettingsHint),
      onLongPress: () {
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => const SettingsPage(),
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ));
      },
      child: Container(
        color: AppColors.background,
        child: Stack(
          children: [
            Center(
              child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  final settings = settingsState is SettingsLoaded ? settingsState.settings : null;
                  return AodClockWidget(
                    style: settings?.aodClockStyle ?? AodClockStyle.digital,
                    scrollSpeedSeconds: settings?.aodScrollSpeedSeconds ?? 30,
                  );
                },
              ),
            ),
            if (_showSettingsHint)
              Positioned(
                bottom: 32,
                right: 32,
                child: Column(
                  children: [
                    const Text(
                      'Hold to open settings',
                      style: TextStyle(color: AppColors.textDim, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Icon(Icons.settings, color: AppColors.textDim.withOpacity(0.5), size: 20),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).then(delay: 3000.ms).fadeOut(),
          ],
        ),
      ),
    );
  }
}

/// Active Mode: sphere animation, session status, timer indicator
class _ActiveScreen extends StatelessWidget {
  const _ActiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _buildPortrait(context)
            : _buildLandscape(context);
      },
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.2,
              colors: [Color(0xFF0D0D1A), AppColors.background],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildTopBar(context),
              Expanded(
                child: Center(
                  child: BlocBuilder<SessionBloc, SessionState>(
                    builder: (ctx, sessionState) => SphereAnimationWidget(
                      phase: sessionState.phase,
                      amplitude: sessionState.audioAmplitude,
                    ),
                  ),
                ),
              ),
              _buildStatusText(context),
              const SizedBox(height: 16),
              BlocBuilder<TimerBloc, TimerState>(
                builder: (ctx, timerState) {
                  if (timerState is TimerIdle) {
                    return TimerStatusWidget(
                      timers: timerState.activeTimers,
                      alarms: timerState.activeAlarms,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.5, 0),
              radius: 1.5,
              colors: [Color(0xFF0D0D1A), AppColors.background],
            ),
          ),
        ),
        SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: BlocBuilder<SessionBloc, SessionState>(
                    builder: (ctx, sessionState) => SphereAnimationWidget(
                      phase: sessionState.phase,
                      amplitude: sessionState.audioAmplitude,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatusText(context),
                    const SizedBox(height: 24),
                    BlocBuilder<TimerBloc, TimerState>(
                      builder: (ctx, timerState) {
                        if (timerState is TimerIdle) {
                          return TimerStatusWidget(
                            timers: timerState.activeTimers,
                            alarms: timerState.activeAlarms,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'GeminiSphere',
            style: TextStyle(
              color: AppColors.textDim,
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.w300,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textDim, size: 20),
            onPressed: () => Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => const SettingsPage(),
              transitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder: (_, anim, __, child) =>
                  SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                        .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                    child: child,
                  ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (ctx, state) {
        String text;
        Color color;
        switch (state.phase) {
          case SessionPhase.idle:
            text = 'Say \"Gemini\" to start';
            color = AppColors.textDim;
            break;
          case SessionPhase.connecting:
            text = 'Connecting...';
            color = AppColors.primaryLight;
            break;
          case SessionPhase.listening:
            text = 'Listening...';
            color = AppColors.primaryLight;
            break;
          case SessionPhase.speaking:
            text = 'GeminiSphere is speaking';
            color = AppColors.secondaryLight;
            break;
          case SessionPhase.toolCalling:
            text = 'Processing...';
            color = AppColors.secondary;
            break;
          case SessionPhase.error:
            text = state.errorMessage ?? 'Error';
            color = AppColors.error;
            break;
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            text,
            key: ValueKey(text),
            style: TextStyle(
              color: color,
              fontSize: 15,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      },
    );
  }
}
