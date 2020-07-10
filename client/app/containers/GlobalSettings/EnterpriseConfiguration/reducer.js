/*
 *
 * Enterprise configuration reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_ENTERPRISE_BEGIN, GET_ENTERPRISE_ERROR,
  GET_ENTERPRISE_SUCCESS, UPDATE_ENTERPRISE_BEGIN,
  UPDATE_ENTERPRISE_SUCCESS, UPDATE_ENTERPRISE_ERROR, CONFIGURATION_UNMOUNT,
} from 'containers/GlobalSettings/EnterpriseConfiguration/constants';

export const initialState = {
  isLoading: true,
  isCommitting: false,
  currentEnterprise: null,
};

/* eslint-disable default-case, no-param-reassign */
function enterpriseReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_ENTERPRISE_ERROR:
        draft.isLoading = false;
        break;
      case GET_ENTERPRISE_SUCCESS:
        draft.currentEnterprise = action.payload.enterprise;
        draft.isLoading = false;
        break;
      case GET_ENTERPRISE_BEGIN:
        draft.isLoading = true;
        break;
      case UPDATE_ENTERPRISE_BEGIN:
        draft.isCommitting = true;
        break;
      case UPDATE_ENTERPRISE_SUCCESS:
      case UPDATE_ENTERPRISE_ERROR:
        draft.isCommitting = false;
        break;
      case CONFIGURATION_UNMOUNT:
        return initialState;
    }
  });
}

export default enterpriseReducer;
