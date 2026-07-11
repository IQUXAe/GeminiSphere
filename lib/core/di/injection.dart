import 'package:get_it/get_it.dart';
import '../../data/datasources/audio/microphone_datasource.dart';
import '../../data/datasources/audio/audio_player_datasource.dart';
import '../../data/datasources/gemini/gemini_live_datasource.dart';
import '../../data/datasources/wake_word/vosk_wake_word_datasource.dart';
import '../../data/datasources/local/notification_datasource.dart';
import '../../data/datasources/local/settings_datasource.dart';
import '../../data/datasources/local/timer_local_datasource.dart';
import '../../data/repositories/gemini_repository_impl.dart';
import '../../data/repositories/audio_repository_impl.dart';
import '../../data/repositories/wake_word_repository_impl.dart';
import '../../data/repositories/timer_repository_impl.dart';
import '../../data/repositories/alarm_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/i_gemini_repository.dart';
import '../../domain/repositories/i_audio_repository.dart';
import '../../domain/repositories/i_wake_word_repository.dart';
import '../../domain/repositories/i_timer_repository.dart';
import '../../domain/repositories/i_alarm_repository.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../domain/usecases/start_gemini_session.dart';
import '../../domain/usecases/stop_gemini_session.dart';
import '../../domain/usecases/send_audio_chunk.dart';
import '../../domain/usecases/handle_tool_call.dart';
import '../../domain/usecases/set_timer.dart';
import '../../domain/usecases/cancel_timer.dart';
import '../../domain/usecases/list_active_timers.dart';
import '../../domain/usecases/set_alarm.dart';
import '../../domain/usecases/cancel_alarm.dart';
import '../../domain/usecases/load_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../../presentation/blocs/session/session_bloc.dart';
import '../../presentation/blocs/timer/timer_bloc.dart';
import '../../presentation/blocs/display/display_bloc.dart';
import '../../presentation/blocs/settings/settings_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // =========================================================
  // Datasources
  // =========================================================
  // Singletons
  final micDs = MicrophoneDataSource();
  final playerDs = AudioPlayerDataSource();
  await playerDs.initialize();
  final geminiDs = GeminiLiveDataSource();
  final voskDs = VoskWakeWordDataSource();
  final notifDs = NotificationDataSource();
  await notifDs.initialize();
  final settingsDs = SettingsDataSource();
  final timerDs = TimerLocalDataSource();
  await timerDs.initialize();

  sl.registerSingleton<MicrophoneDataSource>(micDs);
  sl.registerSingleton<AudioPlayerDataSource>(playerDs);
  sl.registerSingleton<GeminiLiveDataSource>(geminiDs);
  sl.registerSingleton<VoskWakeWordDataSource>(voskDs);
  sl.registerSingleton<NotificationDataSource>(notifDs);
  sl.registerSingleton<SettingsDataSource>(settingsDs);
  sl.registerSingleton<TimerLocalDataSource>(timerDs);

  // =========================================================
  // Repositories
  // =========================================================
  sl.registerLazySingleton<IGeminiRepository>(() => GeminiRepositoryImpl(sl()));
  sl.registerLazySingleton<IAudioRepository>(() => AudioRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ISettingsRepository>(() => SettingsRepositoryImpl(sl()));
  sl.registerLazySingleton<ITimerRepository>(() => TimerRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<IAlarmRepository>(() => AlarmRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<IWakeWordRepository>(() => WakeWordRepositoryImpl(sl(), sl()));

  // =========================================================
  // Use Cases
  // =========================================================
  sl.registerLazySingleton(() => StartGeminiSession(sl()));
  sl.registerLazySingleton(() => StopGeminiSession(sl()));
  sl.registerLazySingleton(() => SendAudioChunk(sl()));
  sl.registerLazySingleton(() => SetTimer(sl()));
  sl.registerLazySingleton(() => CancelTimer(sl()));
  sl.registerLazySingleton(() => ListActiveTimers(sl()));
  sl.registerLazySingleton(() => SetAlarm(sl()));
  sl.registerLazySingleton(() => CancelAlarm(sl()));
  sl.registerLazySingleton(() => LoadSettings(sl()));
  sl.registerLazySingleton(() => SaveSettings(sl()));
  sl.registerLazySingleton(() => HandleToolCall(sl(), sl(), sl(), sl(), sl(), sl()));

  // =========================================================
  // BLoCs
  // =========================================================
  sl.registerFactory(() => SessionBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => TimerBloc(sl(), sl()));
  sl.registerFactory(() => DisplayBloc());
  sl.registerFactory(() => SettingsBloc(sl(), sl()));
}
