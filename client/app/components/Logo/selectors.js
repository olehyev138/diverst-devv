/**
 * The global state selectors
 */

// TODO: put this in App

import { createSelector } from 'reselect';
import { initialState } from 'containers/App/reducer';

const selectGlobal = state => state.global || initialState;

const selectEnterprise = () => createSelector(selectGlobal, substate => substate.enterprise);

export { selectGlobal, selectEnterprise };
