import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectTheme = state => state['theme'] || initialState;

const makeSelectPrimary = () =>
  createSelector(
    selectTheme,
    themeState => themeState.get("primary"));

const makeSelectSecondary = () =>
  createSelector(
    selectTheme,
    themeState => themeState.get("secondary"));

export default makeSelectThemeProvider;
export { selectTheme, makeSelectPrimary, makeSelectSecondary };
