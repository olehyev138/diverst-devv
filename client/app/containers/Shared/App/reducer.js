/*
 * App reducer
 */

// App state is stored as { global: {} } in redux store (see app/reducers.js)

import produce from 'immer/dist/immer';
import {
  LOGIN_SUCCESS, LOGOUT_SUCCESS, LOGOUT_ERROR,
  SET_USER, SET_USER_POLICY_GROUP, SET_ENTERPRISE,
  LOGIN_ERROR
} from 'containers/Shared/App/constants';
import {
  UPDATE_CUSTOM_TEXT_SUCCESS
} from 'containers//GlobalSettings/CustomText/constants';

import { act } from 'react-testing-library';

// The initial state of the App
export const initialState = {
  user: null,
  policyGroup: null,
  enterprise: null,
  token: null
};

function appReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case LOGIN_SUCCESS:
        draft.token = action.token;
        break;
      case LOGOUT_SUCCESS:
        draft.token = initialState.token;
        draft.user = initialState.user;
        draft.policyGroup = initialState.policyGroup;
        break;
      case LOGIN_ERROR:
      case LOGOUT_ERROR:
        draft.error = action.error;
        break;
      case SET_ENTERPRISE:
        draft.enterprise = action.enterprise;
        break;
      case SET_USER_POLICY_GROUP:
        draft.policyGroup = action.policyGroup;
        break;
      case SET_USER:
        // Clear policy group and enterprise because we already have them in the store at the parent level
        draft.user = {
          ...action.user,
          policy_group: undefined,
          enterprise: undefined,
        };
        break;
    }
  });
}

export default appReducer;
