/*
 *
 * Campaign actions
 *
 */

import {
  GET_CAMPAIGNS_BEGIN, GET_CAMPAIGNS_SUCCESS, GET_CAMPAIGNS_ERROR,
  CREATE_CAMPAIGNS_BEGIN, CREATE_CAMPAIGNS_SUCCESS, CREATE_CAMPAIGNS_ERROR,
  UPDATE_CAMPAIGN_BEGIN, UPDATE_CAMPAIGN_SUCCESS, UPDATE_CAMPAIGN_ERROR,
  DELETE_CAMPAIGN_BEGIN, DELETE_CAMPAIGN_SUCCESS, DELETE_CAMPAIGN_ERROR,
  CAMPAIGNS_UNMOUNT
} from 'containers/Innovate/Campaigns/constants';

/* Campaign listing */

export function getCampaignsBegin(payload) {
  return {
    type: GET_CAMPAIGNS_BEGIN,
    payload
  };
}

export function getCampaignsSuccess(payload) {
  return {
    type: GET_CAMPAIGNS_SUCCESS,
    payload
  };
}

export function getCampaignsError(error) {
  return {
    type: GET_CAMPAIGNS_ERROR,
    error,
  };
}

/* Campaign creating */

export function createCampaignsBegin(payload) {
  return {
    type: CREATE_CAMPAIGNS_BEGIN,
    payload,
  };
}

export function createCampaignsSuccess(payload) {
  return {
    type: CREATE_CAMPAIGNS_SUCCESS,
    payload,
  };
}

export function createCampaignsError(error) {
  return {
    type: CREATE_CAMPAIGNS_ERROR,
    error,
  };
}

/* Campaign updating */

export function updateCampaignBegin(payload) {
  return {
    type: UPDATE_CAMPAIGN_BEGIN,
    payload,
  };
}

export function updateCampaignSuccess(payload) {
  return {
    type: UPDATE_CAMPAIGN_SUCCESS,
    payload,
  };
}

export function updateCampaignError(error) {
  return {
    type: UPDATE_CAMPAIGN_ERROR,
    error,
  };
}

/* Campaign deleting */

export function deleteCampaignBegin(payload) {
  return {
    type: DELETE_CAMPAIGN_BEGIN,
    payload,
  };
}

export function deleteCampaignSuccess(payload) {
  return {
    type: DELETE_CAMPAIGN_SUCCESS,
    payload,
  };
}

export function deleteCampaignError(error) {
  return {
    type: DELETE_CAMPAIGN_ERROR,
    error,
  };
}

export function CampaignsUnmount() {
  return {
    type: CAMPAIGNS_UNMOUNT
  };
}
