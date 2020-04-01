/*
 *
 * Pillar reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_PILLAR_BEGIN,
  GET_PILLAR_SUCCESS,
  GET_PILLAR_ERROR,
  GET_PILLARS_BEGIN,
  GET_PILLARS_SUCCESS,
  GET_PILLARS_ERROR,
  CREATE_PILLAR_BEGIN,
  CREATE_PILLAR_SUCCESS,
  CREATE_PILLAR_ERROR,
  UPDATE_PILLAR_BEGIN,
  UPDATE_PILLAR_SUCCESS,
  UPDATE_PILLAR_ERROR,
  DELETE_PILLAR_BEGIN,
  DELETE_PILLAR_SUCCESS,
  DELETE_PILLAR_ERROR,
  PILLARS_UNMOUNT,
} from './constants';

export const initialState = {
  pillarList: [],
  pillarListTotal: null,
  currentPillar: null,
  isFetchingPillars: true,
  isFetchingPillar: true,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function pillarReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_PILLAR_BEGIN:
        draft.isFetchingPillar = true;
        break;

      case GET_PILLAR_SUCCESS:
        draft.currentPillar = action.payload.pillar;
        draft.isFetchingPillar = false;
        break;

      case GET_PILLAR_ERROR:
        draft.isFetchingPillar = false;
        break;

      case GET_PILLARS_BEGIN:
        draft.isFetchingPillars = true;
        draft.hasChanged = false;
        break;

      case GET_PILLARS_SUCCESS:
        draft.pillarList = action.payload.items;
        draft.pillarListTotal = action.payload.total;
        draft.isFetchingPillars = false;
        break;

      case GET_PILLARS_ERROR:
        draft.isFetchingPillars = false;
        break;

      case CREATE_PILLAR_BEGIN:
      case UPDATE_PILLAR_BEGIN:
      case DELETE_PILLAR_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_PILLAR_SUCCESS:
      case UPDATE_PILLAR_SUCCESS:
      case DELETE_PILLAR_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_PILLAR_ERROR:
      case UPDATE_PILLAR_ERROR:
      case DELETE_PILLAR_ERROR:
        draft.isCommitting = false;
        break;

      case PILLARS_UNMOUNT:
        return initialState;
    }
  });
}
export default pillarReducer;
