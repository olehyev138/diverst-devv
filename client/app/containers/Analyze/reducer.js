/*
 *
 * Metrics reducer
 *
 */

import produce from 'immer';
import {
  GET_GROUP_POPULATION_SUCCESS, GET_VIEWS_PER_GROUP_SUCCESS, GET_GROWTH_OF_GROUPS_SUCCESS,
  GET_INITIATIVES_PER_GROUP_SUCCESS, GET_MESSAGES_PER_GROUP_SUCCESS, GET_VIEWS_PER_NEWS_LINK_SUCCESS,
  GET_VIEWS_PER_FOLDER_SUCCESS, GET_VIEWS_PER_RESOURCE_SUCCESS, GET_GROWTH_OF_RESOURCES_SUCCESS,
  GET_GROWTH_OF_USERS_SUCCESS, METRICS_UNMOUNT
} from 'containers/Analyze/constants';

export const initialState = {
  metricsData: {
    groupPopulation: [],
    viewsPerGroup: {},
    growthOfGroups: {},
    initiativesPerGroup: {},
    messagesPerGroup: {},
    viewsPerNewsLink: {},
    viewsPerFolder: {},
    viewsPerResource: {},
    growthOfResources: {},
    growthOfUsers: {},
  }
};

/* eslint-disable default-case, no-param-reassign */
function metricsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_GROUP_POPULATION_SUCCESS:
        draft.metricsData.groupPopulation = action.payload;
        break;
      case GET_VIEWS_PER_GROUP_SUCCESS:
        draft.metricsData.viewsPerGroup = action.payload;
        break;
      case GET_GROWTH_OF_GROUPS_SUCCESS:
        draft.metricsData.growthOfGroups = action.payload;
        break;
      case GET_INITIATIVES_PER_GROUP_SUCCESS:
        draft.metricsData.initiativesPerGroup = action.payload;
        break;
      case GET_MESSAGES_PER_GROUP_SUCCESS:
        draft.metricsData.messagesPerGroup = action.payload;
        break;
      case GET_VIEWS_PER_NEWS_LINK_SUCCESS:
        draft.metricsData.viewsPerNewsLink = action.payload;
        break;
      case GET_VIEWS_PER_FOLDER_SUCCESS:
        draft.metricsData.viewsPerFolder = action.payload;
        break;
      case GET_VIEWS_PER_RESOURCE_SUCCESS:
        draft.metricsData.viewsPerResource = action.payload;
        break;
      case GET_GROWTH_OF_RESOURCES_SUCCESS:
        draft.metricsData.growthOfResources = action.payload;
        break;
      case GET_GROWTH_OF_USERS_SUCCESS:
        draft.metricsData.growthOfUsers = action.payload;
        break;
      case METRICS_UNMOUNT:
        return initialState;
    }
  });
}

export default metricsReducer;
