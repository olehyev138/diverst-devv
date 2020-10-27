/*
 *
 * Region reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_REGIONS_BEGIN,
  GET_REGIONS_SUCCESS,
  GET_REGIONS_ERROR,
  GET_REGION_BEGIN,
  GET_REGION_SUCCESS,
  GET_REGION_ERROR,
  CREATE_REGION_BEGIN,
  CREATE_REGION_SUCCESS,
  CREATE_REGION_ERROR,
  UPDATE_REGION_BEGIN,
  UPDATE_REGION_SUCCESS,
  UPDATE_REGION_ERROR,
  DELETE_REGION_BEGIN,
  DELETE_REGION_SUCCESS,
  DELETE_REGION_ERROR,
  REGION_LIST_UNMOUNT,
  REGION_FORM_UNMOUNT,
  REGION_ALL_UNMOUNT,
} from './constants';

export const initialState = {
  isLoading: true,
  isFormLoading: true,
  isCommitting: false,
  regionList: [],
  regionTotal: null,
  currentRegion: null,
  hasChanged: false,
};

/* eslint-disable default-case, no-param-reassign */
function regionsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    // eslint-disable-next-line default-case
    switch (action.type) {
      case GET_REGION_BEGIN:
        draft.isFormLoading = true;
        break;

      case GET_REGION_SUCCESS:
        draft.currentRegion = action.payload.region;
        draft.isFormLoading = false;
        break;

      case GET_REGION_ERROR:
        draft.isFormLoading = false;
        break;

      case GET_REGIONS_BEGIN:
        draft.isLoading = true;
        break;

      case GET_REGIONS_SUCCESS:
        draft.regionList = action.payload.items;
        draft.regionTotal = action.payload.total;
        draft.isLoading = false;
        break;

      case GET_REGIONS_ERROR:
        draft.isLoading = false;
        break;

      case CREATE_REGION_BEGIN:
      case UPDATE_REGION_BEGIN:
      case DELETE_REGION_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_REGION_SUCCESS:
      case UPDATE_REGION_SUCCESS:
      case DELETE_REGION_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_REGION_ERROR:
      case UPDATE_REGION_ERROR:
      case DELETE_REGION_ERROR:
        draft.isCommitting = false;
        break;

      case REGION_LIST_UNMOUNT:
        draft.isLoading = true;
        draft.regionList = [];
        draft.regionTotal = null;
        break;
      case REGION_FORM_UNMOUNT:
      case REGION_ALL_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function flattenChildrenGroups(regions) {
  /* eslint-disable no-return-assign */
  return regions.reduce((map, region) => {
    map.push(region);
    const con = map.concat(flattenChildrenGroups(region.children || []));
    delete region.children;
    return con;
  }, []);
}

export default regionsReducer;
