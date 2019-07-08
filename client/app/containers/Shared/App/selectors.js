import { createSelector } from 'reselect';
import { initialState } from 'containers/Shared/App/reducer';

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
  globalState => globalState.policy_group
);

const selectUser = () => createSelector(
  selectGlobal,
  globalState => globalState.user
);

const selectIsAuthenticated = () => createSelector(
  selectGlobal,
  globalState => !!globalState.token
);

export {
  selectGlobal, selectRouter, selectLocation,
  selectEnterprise, selectToken, selectUserPolicyGroup,
  selectUser, selectIsAuthenticated,
};
