/*
 *
 * Email reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_EMAIL_BEGIN,
  GET_EMAIL_SUCCESS,
  GET_EMAIL_ERROR,
  GET_EMAILS_BEGIN,
  GET_EMAILS_SUCCESS,
  GET_EMAILS_ERROR,
  UPDATE_EMAIL_BEGIN,
  UPDATE_EMAIL_SUCCESS,
  UPDATE_EMAIL_ERROR,
  EMAILS_UNMOUNT,
} from './constants';

export const initialState = {
  emailList: [],
  emailListTotal: null,
  currentEmail: null,
  isFetchingEmails: false,
  isFetchingEmail: false,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function emailReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_EMAIL_BEGIN:
        draft.isFetchingEmail = true;
        break;

      case GET_EMAIL_SUCCESS:
        draft.currentEmail = action.payload.email;
        draft.isFetchingEmail = false;
        break;

      case GET_EMAIL_ERROR:
        draft.isFetchingEmail = false;
        break;

      case GET_EMAILS_BEGIN:
        draft.isFetchingEmails = true;
        draft.hasChanged = false;
        break;

      case GET_EMAILS_SUCCESS:
        draft.emailList = action.payload.items;
        draft.emailListTotal = action.payload.total;
        draft.isFetchingEmails = false;
        break;

      case GET_EMAILS_ERROR:
        draft.isFetchingEmails = false;
        break;

      case UPDATE_EMAIL_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case UPDATE_EMAIL_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case UPDATE_EMAIL_ERROR:
        draft.isCommitting = false;
        draft.hasChanged = false;
        break;

      case EMAILS_UNMOUNT:
        return initialState;
    }
  });
}
export default emailReducer;
