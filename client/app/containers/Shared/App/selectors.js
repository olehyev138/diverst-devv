import { createSelector } from 'reselect';
import { initialState } from 'containers/Shared/App/reducer';

import dig from 'object-dig';

const selectGlobal = state => state.global || initialState;
const selectRouter = state => state.router;

const selectLocation = () => createSelector(
  selectRouter,
  routerState => routerState.location,
);

const selectEnterprise = () => createSelector(
  selectGlobal,
  globalState => dig(globalState.data, 'enterprise')
);

const selectPermissions = () => createSelector(
  selectGlobal,
  globalState => dig(globalState.data, 'permissions')
);

const selectToken = () => createSelector(
  selectGlobal,
  globalState => globalState.token
);

const selectUserPolicyGroup = () => createSelector(
  selectGlobal,
  globalState => dig(globalState.data, 'policy_group')
);

const selectUser = () => createSelector(
  selectGlobal,
  globalState => globalState.data
);

const selectCustomText = () => createSelector(
  selectGlobal,
  globalState => dig(globalState, 'data', 'enterprise', 'custom_text')
);

const selectMentoringInterests = () => createSelector(
  selectGlobal,
  (globalState) => {
    const mInterests = dig(globalState, 'data', 'enterprise', 'mentoring_interests');
    if (mInterests)
      return mInterests.map(i => ({ label: i.name, value: i.id }));
    return [];
  }
);

const selectMentoringTypes = () => createSelector(
  selectGlobal,
  (globalState) => {
    const mTypes = dig(globalState, 'data', 'enterprise', 'mentoring_types');
    if (mTypes)
      return mTypes.map(i => ({ label: i.name, value: i.id }));
    return [];
  }
);

const selectFindEnterpriseError = () => createSelector(
  selectGlobal,
  globalState => globalState.findEnterpriseError
);

export {
  selectGlobal, selectRouter, selectLocation,
  selectEnterprise, selectToken, selectUserPolicyGroup,
  selectUser, selectCustomText, selectMentoringInterests,
  selectMentoringTypes, selectFindEnterpriseError, selectPermissions
};
