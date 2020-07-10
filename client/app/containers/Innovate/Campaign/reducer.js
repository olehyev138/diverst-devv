/*
 *
 * Campaigns reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_CAMPAIGNS_BEGIN, GET_CAMPAIGNS_ERROR,
  GET_CAMPAIGNS_SUCCESS, GET_CAMPAIGN_BEGIN, GET_CAMPAIGN_SUCCESS,
  GET_CAMPAIGN_ERROR, CAMPAIGNS_UNMOUNT,
  CREATE_CAMPAIGN_BEGIN, CREATE_CAMPAIGN_SUCCESS, CREATE_CAMPAIGN_ERROR,
} from './constants';

export const initialState = {
  isCommitting: false,
  campaignList: [],
  campaignTotal: null,
  isFetchingCampaigns: true,
  isFormLoading: true,
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function campaignsReducer(state = initialState, action) {
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_CAMPAIGNS_BEGIN:
        draft.isFetchingCampaigns = true;
        break;
      case GET_CAMPAIGNS_SUCCESS:
        draft.campaignList = action.payload.items;
        draft.campaignTotal = action.payload.total;
        draft.isFetchingCampaigns = false;
        break;
      case GET_CAMPAIGNS_ERROR:
        draft.isFetchingCampaigns = false;
        break;
      case CREATE_CAMPAIGN_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_CAMPAIGN_SUCCESS:
      case CREATE_CAMPAIGN_ERROR:
        draft.isCommitting = false;
        break;
      case GET_CAMPAIGN_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_CAMPAIGN_SUCCESS:
        draft.currentCampaign = action.payload.campaign;
        draft.isFormLoading = false;
        break;
      case GET_CAMPAIGN_ERROR:
        draft.isFormLoading = false;
        break;
      case CAMPAIGNS_UNMOUNT:
        return initialState;
    }
  });
}

export default campaignsReducer;
