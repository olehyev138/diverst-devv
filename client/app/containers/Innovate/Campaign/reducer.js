/*
 *
 * Campaigns reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_CAMPAIGNS_BEGIN, GET_CAMPAIGNS_ERROR,
  GET_CAMPAIGNS_SUCCESS, CAMPAIGNS_UNMOUNT,
  CREATE_CAMPAIGN_BEGIN, CREATE_CAMPAIGN_SUCCESS, CREATE_CAMPAIGN_ERROR,
} from './constants';

export const initialState = {
  isCommitting: false,
  campaignList: [],
  campaignTotal: null,
  isFetchingCampaigns: true
};

/* eslint-disable default-case, no-param-reassign, consistent-return  */
function campaignsReducer(state = initialState, action) {
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_CAMPAIGNS_BEGIN:
        draft.isFetchingCampaigns = true;
        break;
      case GET_CAMPAIGNS_SUCCESS:
        draft.campaignList = formatCampaigns(action.payload.items);
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
      case CAMPAIGNS_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatCampaigns(campaigns) {
  /* eslint-disable no-return-assign */

  /* Extract user out of each campaign
   *   { group_id: <>, user: { ... }  } -> { first_name: <>, ... }
   */
  return campaigns.reduce((map, campaign) => {
    map.push(campaign.user);
    return map;
  }, []);
}

export default campaignsReducer;
