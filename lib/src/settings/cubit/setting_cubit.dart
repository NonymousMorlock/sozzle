import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sozzle/src/settings/domain/i_setting_repository.dart';
import 'package:sozzle/src/settings/domain/settings.dart';
import 'package:sozzle/src/theme/cubit/theme_cubit.dart';
import 'package:sozzle/utilities/settings_helper.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit({
    required this.settingRep,
    required this.themeCubit,
  }) : super(SettingState.initial());
  final ISettingRepository settingRep;
  final ThemeCubit themeCubit;

  Future<void> initialize() async {
    final setting = await settingRep.getSetting();
    final newSettingState = state.copyWith(
      isSoundOn: setting.isSoundOn,
      isMusicOn: setting.isMusicOn,
      isDarkMode: setting.isDarkMode,
      isMute: setting.isMute,
    );
    emit(newSettingState);
  }

  Future<void> toggleSoundOption({required bool val}) async {
    final newState = state.copyWith(
      isSoundOn: val,
      isMute: !state.isMusicOn && !val,
    );

    await settingRep.setSoundSetting(value: val, cache: true);
    await settingRep.setMuteSetting(value: newState.isMute);
    emit(newState);
  }

  Future<void> toggleMusicOption({required bool val}) async {
    final newState = state.copyWith(
      isMusicOn: val,
      isMute: !state.isSoundOn && !val,
    );
    await settingRep.setMusicSetting(value: val, cache: true);
    await settingRep.setMuteSetting(
      value: newState.isMute,
    );
    emit(newState);
  }

  Future<void> toggleDarkModeOption({required bool val}) async {
    final newState = state.copyWith(isDarkMode: val);
    await settingRep.setDarkModeSetting(value: val);

    if (newState.isDarkMode) {
      await themeCubit.getThemeDark();
    } else {
      await themeCubit.getThemeLight();
    }

    emit(newState);
  }

  Future<void> toggleMuteOption({required bool val}) async {
    Settings? cache;
    if (!val) {
      cache = await settingRep.getSetting();
    } else {
      await settingRep.setMusicSetting(value: state.isMusicOn, cache: true);
      await settingRep.setSoundSetting(value: state.isSoundOn, cache: true);
    }
    final newState = state.copyWith(
      isMute: val,
      isMusicOn: SettingsHelper.turnOffSoundAndMusicMaybe(val: val) ??
          cache!.isMusicOnCache,
      isSoundOn: SettingsHelper.turnOffSoundAndMusicMaybe(val: val) ??
          cache!.isSoundOnCache,
    );

    await settingRep.setMuteSetting(value: val);
    await settingRep.setMusicSetting(value: newState.isMusicOn);
    await settingRep.setSoundSetting(value: newState.isSoundOn);

    emit(newState);
  }
}
