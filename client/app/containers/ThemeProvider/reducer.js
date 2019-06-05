/*
 *
 * ThemeProvider reducer
 *
 */

import produce from 'immer';
import { CHANGE_PRIMARY, CHANGE_SECONDARY } from './constants';

// TODO: move primary, secondary defaults
export const initialState = {
  primary: '#7B77C9',
  secondary: '#8A8A8A'
};

function themeProviderReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case CHANGE_PRIMARY:
        return draft.primary = action.color;
      case CHANGE_SECONDARY:
        return draft.secondary = action.color;
    }
  });
}

export default themeProviderReducer;
