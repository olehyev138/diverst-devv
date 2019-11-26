import { createSelector } from 'reselect/lib/index';
import { initialState } from './reducer';
import produce from 'immer';
import dig from 'object-dig';

const selectConfigurationDomain = state => state.configuration || initialState;

const selectEnterprise = () => createSelector(
  selectConfigurationDomain,
  configurationState => configurationState.currentEnterprise
);

const selectFormEnterprise = () => createSelector(
  selectConfigurationDomain,
  (configurationState) => {
    const enterprise = configurationState.currentEnterprise;

    if (enterprise) {
      const timezoneArray = enterprise.timezones;
      return produce(enterprise, (draft) => {
        draft.timezones = timezoneArray.map((element) => {
          if (element[1] === enterprise.time_zone)
            draft.time_zone = { label: element[1], value: element[0] };
          return { label: element[1], value: element[0] };
        });
      });
    }

    return null;
  }
);

/* Selects the enterprise theme, used by Branding components */
const selectEnterpriseTheme = () => createSelector(
  selectConfigurationDomain,
  configurationState => dig(configurationState.currentEnterprise, 'theme')
);

const selectEnterpriseIsLoading = () => createSelector(
  selectConfigurationDomain,
  configurationState => configurationState.isLoading
);

const selectEnterpriseIsCommitting = () => createSelector(
  selectConfigurationDomain,
  configurationState => configurationState.isCommitting
);

export {
  selectConfigurationDomain, selectEnterprise, selectEnterpriseIsLoading,
  selectEnterpriseIsCommitting, selectFormEnterprise, selectEnterpriseTheme
};
