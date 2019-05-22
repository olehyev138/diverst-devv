/*
 * App reducer
 */

// App state is stored as { global: {} } in redux store (see app/reducers.js)

import produce from 'immer';
import {
  LOGIN_SUCCESS, LOGOUT_SUCCESS, LOGOUT_ERROR,
  SET_USER, SET_ENTERPRISE
} from "./constants";

// The initial state of the App
export const initialState = {
  loading: false,
  user: null,
  enterprise: null,
  domain: null,
  token: null,
  primary: "#3f51b5",
  secondary: "#f50057"
};

function appReducer(state = initialState, action) {
  return produce(state, draft => {
    switch (action.type) {
      case LOGIN_SUCCESS:
        draft['token'] = action.token;
        break;
      case LOGOUT_SUCCESS:
        draft['token'] = null;
        break;
      case LOGOUT_ERROR:
        draft['error'] = action.error;
        break;
      case SET_ENTERPRISE:
        draft['enterprise'] = action.enterprise;
        break;
      case SET_USER:
        draft['user'] = action.user;
        break;
    }
  });
}

export default appReducer;
