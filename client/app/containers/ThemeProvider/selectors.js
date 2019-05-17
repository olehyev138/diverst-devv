import { createSelector } from "reselect";
import { initialState } from "./reducer";

/**
 * Direct selector to the languageToggle state domain
 */
const selectTheme = state => state.get("theme", initialState);

/**
 * Select the language locale
 */

const makeSelectPrimary = () =>
    createSelector(selectTheme, themeState => themeState.get("primary"));

const makeSelectSecondary = () =>
    createSelector(selectTheme, themeState => themeState.get("secondary"));

export { selectTheme, makeSelectPrimary, makeSelectSecondary };
