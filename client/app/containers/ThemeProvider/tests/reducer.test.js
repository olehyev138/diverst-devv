import produce from 'immer';
import themeProviderReducer from '../reducer';
import { changePrimary, changeSecondary } from '../actions';

/* eslint-disable default-case, no-param-reassign */
describe('themeProviderReducer', () => {
  let state;

  beforeEach(() => {
    state = {
      primary: '#7B77C9',
      secondary: '#8A8A8A'
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(themeProviderReducer(undefined, {})).toEqual(expected);
  });

  it('handles CHANGE_PRIMARY', () => {
    const expected = produce(state, (draft) => {
      draft.primary = 'color';
    });

    expect(themeProviderReducer(state, changePrimary('color'))).toEqual(expected);
  });

  it('handles CHANGE_SECONDARY', () => {
    const expected = produce(state, (draft) => {
      draft.secondary = 'color';
    });

    expect(themeProviderReducer(state, changeSecondary('color'))).toEqual(expected);
  });
});
