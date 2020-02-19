/*
 * App reducer
 */

// App state is stored as { global: {} } in redux store (see app/reducers.js)

import produce from 'immer/dist/immer';
import { LOGIN_SUCCESS, LOGOUT_SUCCESS, SET_USER_DATA } from 'containers/Shared/App/constants';

// The initial state of the App
export const initialState = {
  token: null,
  data: null,
};

function appReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case LOGIN_SUCCESS:
        draft.token = action.token;
        break;
      case LOGOUT_SUCCESS:
        draft.token = initialState.token;
        draft.data = initialState.data;
        break;
      case SET_USER_DATA:
        if (action.append === true)
          draft.data = { ...draft.data, ...action.payload };
        else
          draft.data = action.payload;
        break;
    }
  });
}

export default appReducer;
