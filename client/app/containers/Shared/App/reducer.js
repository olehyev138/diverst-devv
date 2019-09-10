/*
 * App reducer
 */

// App state is stored as { global: {} } in redux store (see app/reducers.js)

import produce from 'immer/dist/immer';
import {
  LOGIN_SUCCESS, LOGOUT_SUCCESS, LOGOUT_ERROR,
  SET_USER, SET_USER_POLICY_GROUP, SET_ENTERPRISE
} from 'containers/Shared/App/constants';

// The initial state of the App
export const initialState = {
  user: null,
  policyGroup: null,
  enterprise: null,
  token: null,
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
        // Clear policy group because we already have it in the store at the parent level
        draft.user = {
          ...action.user,
          policy_group: undefined,
        };
        break;
    }
  });
}

export default appReducer;
