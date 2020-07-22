/*
 * App reducer
 */

// App state is stored as { global: {} } in redux store (see app/reducers.js)

import produce from 'immer/dist/immer';
import {
  LOGIN_SUCCESS,
  LOGOUT_SUCCESS,
  SET_USER_DATA,
  FIND_ENTERPRISE_BEGIN,
  FIND_ENTERPRISE_ERROR,
  FETCH_USER_DATA_BEGIN,
  FETCH_USER_DATA_SUCCESS,
  FETCH_USER_DATA_ERROR,
  TOGGLE_ADMIN_DRAWER
} from 'containers/Shared/App/constants';
import dig from 'object-dig';

// The initial state of the App
export const initialState = {
  token: null,
  data: null,
  findEnterpriseError: false,
  isFetchingUserData: true,
  fetchUserDataError: false,
  adminDrawerOpen: false,
};

function appReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case LOGIN_SUCCESS:
        draft.token = action.token;
        break;
      case LOGOUT_SUCCESS:
        draft.token = initialState.token;
        draft.data = { enterprise: dig(draft.data, 'enterprise') };
        break;
      case SET_USER_DATA:
        if (action.append === true)
          draft.data = { ...draft.data, ...action.payload };
        else
          draft.data = action.payload;
        break;
      case FIND_ENTERPRISE_BEGIN:
        // Note: this is to prevent an ugly double rerender on locale change
        if (draft.data && draft.data.enterprise)
          draft.data.enterprise = undefined;
        break;
      case FIND_ENTERPRISE_ERROR:
        draft.findEnterpriseError = true;
        break;
      case FETCH_USER_DATA_BEGIN:
        draft.isFetchingUserData = true;
        draft.fetchUserDataError = false;
        break;
      case FETCH_USER_DATA_SUCCESS:
        draft.isFetchingUserData = false;
        break;
      case FETCH_USER_DATA_ERROR:
        draft.isFetchingUserData = false;
        draft.fetchUserDataError = true;
        break;
      case TOGGLE_ADMIN_DRAWER:
        if (action.setTo !== undefined)
          draft.adminDrawerOpen = action.setTo;
        else
          draft.adminDrawerOpen = !draft.adminDrawerOpen;
        break;
    }
  });
}

export default appReducer;
