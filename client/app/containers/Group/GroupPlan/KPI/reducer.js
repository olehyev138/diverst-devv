/*
 *
 * Kpi reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_UPDATE_BEGIN,
  GET_UPDATE_SUCCESS,
  GET_UPDATE_ERROR,
  GET_UPDATES_BEGIN,
  GET_UPDATES_SUCCESS,
  GET_UPDATES_ERROR,
  CREATE_UPDATE_BEGIN,
  CREATE_UPDATE_SUCCESS,
  CREATE_UPDATE_ERROR,
  UPDATE_UPDATE_BEGIN,
  UPDATE_UPDATE_SUCCESS,
  UPDATE_UPDATE_ERROR,
  DELETE_UPDATE_BEGIN,
  DELETE_UPDATE_SUCCESS,
  DELETE_UPDATE_ERROR,
  GET_FIELD_BEGIN,
  GET_FIELD_SUCCESS,
  GET_FIELD_ERROR,
  GET_FIELDS_BEGIN,
  GET_FIELDS_SUCCESS,
  GET_FIELDS_ERROR,
  CREATE_FIELD_BEGIN,
  CREATE_FIELD_SUCCESS,
  CREATE_FIELD_ERROR,
  UPDATE_FIELD_BEGIN,
  UPDATE_FIELD_SUCCESS,
  UPDATE_FIELD_ERROR,
  DELETE_FIELD_BEGIN,
  DELETE_FIELD_SUCCESS,
  DELETE_FIELD_ERROR,
  FIELDS_UNMOUNT,
} from './constants';

export const initialState = {
  updateList: [],
  updateListTotal: null,
  currentUpdate: null,
  isFetchingUpdates: false,
  isFetchingUpdate: false,
  isCommittingUpdate: false,
  hasChangedUpdate: false,

  fieldList: [],
  fieldListTotal: null,
  currentField: null,
  isFetchingFields: false,
  isFetchingField: false,
  isCommittingField: false,
  hasChangedField: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function kpiReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_UPDATE_BEGIN:
        draft.isFetchingUpdates = true;
        break;

      case GET_FIELD_BEGIN:
        draft.isFetchingFields = true;
        break;

      case GET_UPDATE_SUCCESS:
        draft.currentUpdate = action.payload.kpi;
        draft.isFetchingUpdates = false;
        break;

      case GET_FIELD_SUCCESS:
        draft.currentField = action.payload.kpi;
        draft.isFetchingFields = false;
        break;

      case GET_UPDATE_ERROR:
        draft.isFetchingUpdates = false;
        break;

      case GET_FIELD_ERROR:
        draft.isFetchingFields = false;
        break;

      case GET_UPDATES_BEGIN:
        draft.isFetchingUpdates = true;
        draft.hasChangedUpdate = false;
        break;

      case GET_FIELDS_BEGIN:
        draft.isFetchingFields = true;
        draft.hasChangedFields = false;
        break;

      case GET_UPDATES_SUCCESS:
        draft.updateList = action.payload.items;
        draft.updateListTotal = action.payload.total;
        draft.isFetchingUpdates = false;
        break;

      case GET_FIELDS_SUCCESS:
        draft.fieldList = action.payload.items;
        draft.fieldListTotal = action.payload.total;
        draft.isFetchingFields = false;
        break;

      case GET_UPDATES_ERROR:
        draft.isFetchingKpis = false;
        break;


      case GET_FIELDS_ERROR:
        draft.isFetchingFields = false;
        break;

      case CREATE_UPDATE_BEGIN:
      case UPDATE_UPDATE_BEGIN:
      case DELETE_UPDATE_BEGIN:
        draft.isCommittingUpdate = true;
        draft.hasChangedUpdate = false;
        break;

      case CREATE_FIELD_BEGIN:
      case UPDATE_FIELD_BEGIN:
      case DELETE_FIELD_BEGIN:
        draft.isCommittingField = true;
        draft.hasChangedFields = false;
        break;

      case CREATE_UPDATE_SUCCESS:
      case UPDATE_UPDATE_SUCCESS:
      case DELETE_UPDATE_SUCCESS:
        draft.isCommittingUpdate = false;
        draft.hasChangedUpdate = true;
        break;

      case CREATE_FIELD_SUCCESS:
      case UPDATE_FIELD_SUCCESS:
      case DELETE_FIELD_SUCCESS:
        draft.isCommittingField = false;
        draft.hasChangedFields = true;
        break;

      case CREATE_UPDATE_ERROR:
      case UPDATE_UPDATE_ERROR:
      case DELETE_UPDATE_ERROR:
        draft.isCommittingUpdate = false;
        break;

      case CREATE_FIELD_ERROR:
      case UPDATE_FIELD_ERROR:
      case DELETE_FIELD_ERROR:
        draft.isCommittingField = false;
        break;

      case FIELDS_UNMOUNT:
        return initialState;
    }
  });
}
export default kpiReducer;
