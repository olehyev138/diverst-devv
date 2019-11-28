import { createSelector } from 'reselect/lib/index';
import { initialState } from './reducer';
import produce from 'immer';

const selectSettingsDomain = state => state.settings || initialState;

const selectSettings = () => createSelector(
  selectSettingsDomain,
  settingsState => settingsState.currentSSOSetting
);

const selectFormSettings = () => createSelector(
  selectSettingsDomain,
  (settingsState) => {
    const setting = settingsState.currentSSOSetting;

    if (setting) {
      const timezoneArray = setting.timezones;
      return produce(setting, (draft) => {
        draft.timezones = timezoneArray.map((element) => {
          if (element[1] === setting.time_zone)
            draft.time_zone = { label: element[1], value: element[0] };
          return { label: element[1], value: element[0] };
        });
      });
    }

    return null;
  }
);

const selectSettingIsLoading = () => createSelector(
  selectSettingsDomain,
  settingsState => settingsState.isLoading
);

const selectSettingIsCommitting = () => createSelector(
  selectSettingsDomain,
  settingsState => settingsState.isCommitting
);

export {
  selectSettingsDomain, selectSettings, selectSettingIsLoading,
  selectSettingIsCommitting, selectFormSettings
};
