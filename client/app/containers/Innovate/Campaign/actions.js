/*
 *
 * Campaign actions
 *
 */

import {
  GET_CAMPAIGNS_BEGIN, GET_CAMPAIGNS_SUCCESS, GET_CAMPAIGNS_ERROR,
  CREATE_CAMPAIGN_BEGIN, CREATE_CAMPAIGN_SUCCESS, CREATE_CAMPAIGN_ERROR,
  UPDATE_CAMPAIGN_BEGIN, UPDATE_CAMPAIGN_SUCCESS, UPDATE_CAMPAIGN_ERROR,
  DELETE_CAMPAIGN_BEGIN, DELETE_CAMPAIGN_SUCCESS, DELETE_CAMPAIGN_ERROR,
  CAMPAIGNS_UNMOUNT
} from 'containers/Innovate/Campaign/constants';

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

/* Campaign Getting */

export function getCampaignBegin(payload) {
  return {
    type: GET_CAMPAIGNS_BEGIN,
    payload
  };
}

export function getCampaignSuccess(payload) {
  return {
    type: GET_CAMPAIGNS_SUCCESS,
    payload
  };
}

export function getCampaignError(error) {
  return {
    type: GET_CAMPAIGNS_ERROR,
    error,
  };
}

/* Campaign creating */

export function createCampaignBegin(payload) {
  return {
    type: CREATE_CAMPAIGN_BEGIN,
    payload,
  };
}

export function createCampaignSuccess(payload) {
  return {
    type: CREATE_CAMPAIGN_SUCCESS,
    payload,
  };
}

export function createCampaignError(error) {
  return {
    type: CREATE_CAMPAIGN_ERROR,
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

export function campaignsUnmount() {
  return {
    type: CAMPAIGNS_UNMOUNT
  };
}
