import { createSelector } from 'reselect';
import { initialState } from './reducer';

const selectTheme = state => state.theme || initialState;

const makeSelectPrimary = () => createSelector(
  selectTheme,
  themeState => themeState.primary
);

const makeSelectSecondary = () => createSelector(
  selectTheme,
  themeState => themeState.secondary
);

export { selectTheme, makeSelectPrimary, makeSelectSecondary };
