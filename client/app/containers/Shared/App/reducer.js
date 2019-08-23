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

// The initial state of the App
export const initialState = {
  user: null,
  policy_group: null,
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
        draft.policy_group = initialState.policy_group;
        break;
      case LOGIN_ERROR:
      case LOGOUT_ERROR:
        draft.error = action.error;
        break;
      case SET_ENTERPRISE:
        draft.enterprise = action.enterprise;
        break;
      case SET_USER_POLICY_GROUP:
        draft.policy_group = action.payload.policy_group;
        break;
      case SET_USER:
        draft.user = action.user;
        break;
    }
  });
}

export default appReducer;
