import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectSSOSettingsDomain = state => state.SSOSettings || initialState;

const selectIsCommitting = () => createSelector(
  selectSSOSettingsDomain,
  SSOSettingsState => SSOSettingsState.isCommitting
);

export {
  selectSSOSettingsDomain,
  selectIsCommitting,
};
