import { createSelector } from 'reselect';
import { initialState } from 'containers/Shared/App/reducer';

import dig from 'object-dig';

const selectGlobal = state => state.global || initialState;
const selectRouter = state => state.router;

const selectLocation = () => createSelector(
  selectRouter,
  routerState => routerState.location,
);

const selectEnterprise = () => createSelector(selectGlobal,
  globalState => globalState.enterprise);

const selectToken = () => createSelector(
  selectGlobal,
  globalState => globalState.token
);

const selectUserPolicyGroup = () => createSelector(
  selectGlobal,
  globalState => globalState.policyGroup
);

const selectUser = () => createSelector(
  selectGlobal,
  globalState => globalState.user
);

const selectCustomText = () => createSelector(
  selectGlobal,
  globalState => dig(globalState, 'enterprise', 'custom_text')
);

export {
  selectGlobal, selectRouter, selectLocation,
  selectEnterprise, selectToken, selectUserPolicyGroup,
  selectUser, selectCustomText,
};
