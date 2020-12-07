import { createSelector } from 'reselect';
import { initialState } from 'containers/Shared/App/reducer';

const selectGlobal = state => state.global || initialState;
const selectRouter = state => state.router;

const selectLocation = () => createSelector(
  selectRouter,
  routerState => routerState.location,
);

const selectEnterprise = () => createSelector(
  selectGlobal,
  globalState => globalState.data?.enterprise
);

const selectEnterprisePrivacyMessage = () => createSelector(
  selectGlobal,
  globalState => globalState.data.enterprise?.privacy_statement
);

const selectPermissions = () => createSelector(
  selectGlobal,
  globalState => globalState.data?.permissions
);

const selectBudgetPeriod = () => createSelector(
  selectGlobal,
  globalState => globalState.data?.current_budget_period
);

const selectToken = () => createSelector(
  selectGlobal,
  globalState => globalState.token
);

const selectUserPolicyGroup = () => createSelector(
  selectGlobal,
  globalState => globalState.data?.policy_group
);

const selectUser = () => createSelector(
  selectGlobal,
  globalState => globalState.data
);

const selectIsFetchingUserData = () => createSelector(
  selectGlobal,
  globalState => globalState.isFetchingUserData
);

const selectFetchUserDataError = () => createSelector(
  selectGlobal,
  globalState => globalState.fetchUserDataError
);

const selectCustomText = () => createSelector(
  selectGlobal,
  globalState => globalState?.data?.enterprise?.custom_text
);

const selectMentoringInterests = () => createSelector(
  selectGlobal,
  (globalState) => {
    const mInterests = globalState?.data?.enterprise?.mentoring_interests;
    if (mInterests)
      return mInterests.map(i => ({ label: i.name, value: i.id }));
    return [];
  }
);

const selectMentoringTypes = () => createSelector(
  selectGlobal,
  (globalState) => {
    const mTypes = globalState?.data?.enterprise?.mentoring_types;
    if (mTypes)
      return mTypes.map(i => ({ label: i.name, value: i.id }));
    return [];
  }
);

const selectFindEnterpriseError = () => createSelector(
  selectGlobal,
  globalState => globalState.findEnterpriseError
);

const selectAdminDrawerOpen = () => createSelector(
  selectGlobal,
  globalState => globalState.adminDrawerOpen
);

export {
  selectGlobal, selectRouter, selectLocation,
  selectEnterprise, selectToken, selectUserPolicyGroup,
  selectUser, selectIsFetchingUserData, selectFetchUserDataError,
  selectCustomText, selectMentoringInterests, selectMentoringTypes,
  selectFindEnterpriseError, selectPermissions, selectEnterprisePrivacyMessage,
  selectAdminDrawerOpen, selectBudgetPeriod,
};
