/**
 * The global state selectors
 */

import { createSelector } from "reselect";
import { initialState } from "containers/App/reducer";

const selectHome = state => state.get("global", initialState);

const makeSelectEnterprise = () => createSelector(selectHome, state => state.get("enterprise"));

export { makeSelectEnterprise };
