import { createSelector } from 'reselect/lib/index';
import { initialState } from './reducer';

const selectConfigurationDomain = state => state.configuration || initialState;

const selectEnterprise = () => createSelector(
  selectConfigurationDomain,
  configurationState => configurationState.currentEnterprise
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
  selectEnterpriseIsCommitting
};
