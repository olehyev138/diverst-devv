/**
 * The global state selectors
 */

import { createSelector } from "reselect";
import { initialState } from "containers/App/reducer";

const selectHome = state => state.get("global", initialState);

const makeSelectToken = () => createSelector(selectHome, state => state.get("token"));
const makeSelectUser = () => createSelector(selectHome, state => state.get("currentUser"));
const makeSelectEnterprise = () => createSelector(selectHome, state => state.get("enterprise"));

export { selectHome, makeSelectToken, makeSelectUser, makeSelectEnterprise };
