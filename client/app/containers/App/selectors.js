import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectRouter = state => state.router;
const selectGlobal = state => state.global || initialState;

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
  selectRouter, selectLocation, selectEnterprise, selectToken, selectUser
};
