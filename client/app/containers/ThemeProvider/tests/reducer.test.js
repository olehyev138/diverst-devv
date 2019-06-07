// import produce from 'immer';
import themeProviderReducer from '../reducer';
import { CHANGE_PRIMARY, CHANGE_SECONDARY } from '../constants';

/* eslint-disable default-case, no-param-reassign */
describe('themeProviderReducer', () => {
  it('returns the initial state', () => {
    const expectedResult = {
      primary: '#7B77C9',
      secondary: '#8A8A8A'
    };

    expect(themeProviderReducer(undefined, {})).toEqual(expectedResult);
  });

  it('handles CHANGE_PRIMARY', () => {
    const action = { type: CHANGE_PRIMARY, color: 'primary' };

    expect(themeProviderReducer(undefined, action)).toEqual({
      primary: 'primary',
      secondary: '#8A8A8A'
    });
  });

  it('handles CHANGE_SECONDARY', () => {
    const action = { type: CHANGE_SECONDARY, color: 'secondary' };

    expect(themeProviderReducer(undefined, action)).toEqual({
      primary: '#7B77C9',
      secondary: 'secondary'
    });
  });
});
