/*
 *
 * Sponsors reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_SPONSORS_BEGIN, GET_SPONSORS_ERROR,
  GET_SPONSORS_SUCCESS, GET_SPONSOR_BEGIN, GET_SPONSOR_SUCCESS,
  GET_SPONSOR_ERROR, SPONSORS_UNMOUNT,
  CREATE_SPONSOR_BEGIN, CREATE_SPONSOR_SUCCESS, CREATE_SPONSOR_ERROR,
  DELETE_SPONSOR_BEGIN, DELETE_SPONSOR_ERROR, DELETE_SPONSOR_SUCCESS
} from './constants';


export const initialState = {
  isCommitting: false,
  sponsorList: [],
  sponsorTotal: null,
  currentSponsor: null,
  hasChanged: false,
  isFetchingSponsors: true
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function sponsorsReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_SPONSORS_BEGIN:
        draft.isFetchingSponsors = true;
        break;
      case GET_SPONSORS_SUCCESS:
        draft.sponsorList = action.payload.items;
        draft.sponsorTotal = action.payload.total;
        draft.isFetchingSponsors = false;
        break;
      case GET_SPONSORS_ERROR:
        draft.isFetchingSponsors = false;
        break;
      case CREATE_SPONSOR_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_SPONSOR_SUCCESS:
      case CREATE_SPONSOR_ERROR:
        draft.isCommitting = false;
        break;
      case GET_SPONSOR_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_SPONSOR_SUCCESS:
        draft.currentSponsor = action.payload.sponsor;
        draft.isFormLoading = false;
        break;
      case GET_SPONSOR_ERROR:
        draft.isFormLoading = false;
        break;
      case DELETE_SPONSOR_BEGIN:
        draft.hasChanged = false;
        break;
      case DELETE_SPONSOR_SUCCESS:
        draft.hasChanged = true;
        break;
      case SPONSORS_UNMOUNT:
        return initialState;
    }
  });
}

export default sponsorsReducer;
