import { createSelector } from 'reselect';
import { initialState } from './reducer';

/**
 * Direct selector to the loginPage state domain
 */

const selectGlobal = state => state.global || initialState;

/**
 * Other specific selectors
 */

/**
 * Default selector used by LoginPage
 */

const selectEnterprise = () => createSelector(selectGlobal, substate => substate['enterprise']);

export { selectGlobal, selectEnterprise };
