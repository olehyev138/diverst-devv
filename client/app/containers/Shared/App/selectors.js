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

const selectUser = () => createSelector(
  selectGlobal,
  globalState => globalState.user
);

export {
  selectGlobal, selectRouter, selectLocation,
  selectEnterprise, selectToken, selectUser
};
