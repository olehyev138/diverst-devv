import { createSelector } from 'reselect';
import { initialState } from 'containers/App/reducer';

// TODO: move all of this to App/

const selectGlobal = state => state.global || initialState;

const selectToken = () =>
  createSelector(
    selectGlobal,
    substate => substate['token']
  );

const selectUser = () =>
  createSelector(
    selectGlobal,
    substate => substate['user']
  );

const selectEnterprise = () =>
  createSelector(
    selectGlobal,
    substate => substate['enterprise']
  );

export { selectGlobal, selectToken, selectUser, selectEnterprise }
