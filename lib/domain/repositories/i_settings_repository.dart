import 'package:dartz/dartz.dart';
import '../entities/app_settings.dart';
import '../../core/errors/failures.dart';

abstract interface class ISettingsRepository {
  Future<Either<Failure, AppSettings>> loadSettings();

  Future<Either<Failure, void>> saveSettings(AppSettings settings);

  Future<Either<Failure, void>> clearSettings();
}
