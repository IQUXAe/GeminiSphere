import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../datasources/local/settings_datasource.dart';

@LazySingleton(as: ISettingsRepository)
class SettingsRepositoryImpl implements ISettingsRepository {
  final SettingsDataSource _dataSource;
  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, AppSettings>> loadSettings() async {
    try {
      final settings = await _dataSource.loadSettings();
      return Right(settings);
    } on StorageException catch (e) {
      return Left(Failure.storage(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(AppSettings settings) async {
    try {
      await _dataSource.saveSettings(settings);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(Failure.storage(message: e.message));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSettings() async {
    try {
      await _dataSource.clearSettings();
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
