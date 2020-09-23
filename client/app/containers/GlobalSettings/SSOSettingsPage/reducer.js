/*
 *
 * Sso Settings reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  UPDATE_SSO_SETTINGS_BEGIN,
  UPDATE_SSO_SETTINGS_SUCCESS,
  UPDATE_SSO_SETTINGS_ERROR,
} from './constants';

export const initialState = {
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function SSOSettingsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case UPDATE_SSO_SETTINGS_BEGIN:
        draft.isCommitting = true;
        break;

      case UPDATE_SSO_SETTINGS_SUCCESS:
        draft.isCommitting = false;
        break;

      case UPDATE_SSO_SETTINGS_ERROR:
    }
  });
}
export default SSOSettingsReducer;
