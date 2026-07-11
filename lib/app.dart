import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/i_audio_repository.dart';
import 'presentation/blocs/session/session_bloc.dart';
import 'presentation/blocs/timer/timer_bloc.dart';
import 'presentation/blocs/display/display_bloc.dart';
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/settings/settings_event.dart';
import 'presentation/pages/home_page.dart';

class GeminiSphereApp extends StatefulWidget {
  const GeminiSphereApp({super.key});

  @override
  State<GeminiSphereApp> createState() => _GeminiSphereAppState();
}

class _GeminiSphereAppState extends State<GeminiSphereApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // iOS: Start silence loop to keep app alive in background
    if (Platform.isIOS) {
      sl<IAudioRepository>().startSilenceLoop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionBloc>(create: (_) => sl<SessionBloc>()),
        BlocProvider<TimerBloc>(create: (_) => sl<TimerBloc>()),
        BlocProvider<DisplayBloc>(create: (_) => sl<DisplayBloc>()),
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(const LoadSettingsEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'GeminiSphere',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const HomePage(),
      ),
    );
  }
}
