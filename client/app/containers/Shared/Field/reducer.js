/*
 *
 * Field reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_FIELDS_SUCCESS, GET_FIELD_SUCCESS,
  FIELD_LIST_UNMOUNT, FIELD_FORM_UNMOUNT,
  GET_FIELDS_BEGIN, GET_FIELDS_ERROR, GET_FIELD_ERROR,
  CREATE_FIELD_BEGIN, CREATE_FIELD_SUCCESS, CREATE_FIELD_ERROR,
  UPDATE_FIELD_BEGIN, UPDATE_FIELD_SUCCESS, UPDATE_FIELD_ERROR,
  UPDATE_FIELD_POSITION_BEGIN, UPDATE_FIELD_POSITION_SUCCESS, UPDATE_FIELD_POSITION_ERROR,
  DELETE_FIELD_BEGIN, DELETE_FIELD_SUCCESS, DELETE_FIELD_ERROR,
} from 'containers/Shared/Field/constants';

export const initialState = {
  isLoading: true,
  isCommitting: false,
  commitSuccess: undefined,
  fieldList: [],
  fieldTotal: null,
  currentField: null,
  hasChanged: false,
};

/* eslint-disable default-case, no-param-reassign */
function fieldsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_FIELDS_BEGIN:
        draft.isLoading = true;
        break;
      case GET_FIELDS_SUCCESS:
        draft.fieldList = action.payload.items;
        draft.fieldTotal = action.payload.total;
        draft.isLoading = false;
        break;
      case GET_FIELDS_ERROR:
        draft.isLoading = false;
        break;
      case GET_FIELD_SUCCESS:
        draft.currentField = action.payload.field;
        draft.isLoading = false;
        break;
      case GET_FIELD_ERROR:
        draft.isLoading = false;
        break;
      case CREATE_FIELD_BEGIN:
        draft.isCommitting = true;
        draft.commitSuccess = undefined;
        break;
      case UPDATE_FIELD_BEGIN:
      case UPDATE_FIELD_POSITION_BEGIN:
      case DELETE_FIELD_BEGIN:
        draft.isCommitting = true;
        draft.commitSuccess = undefined;
        draft.hasChanged = false;
        break;
      case CREATE_FIELD_SUCCESS:
        draft.isCommitting = false;
        draft.commitSuccess = true;
        draft.hasChanged = true;
        break;
      case UPDATE_FIELD_SUCCESS:
      case UPDATE_FIELD_POSITION_SUCCESS:
      case DELETE_FIELD_SUCCESS:
        draft.isCommitting = false;
        draft.commitSuccess = true;
        draft.hasChanged = true;
        break;
      case CREATE_FIELD_ERROR:
      case UPDATE_FIELD_ERROR:
      case UPDATE_FIELD_POSITION_ERROR:
      case DELETE_FIELD_ERROR:
        draft.isCommitting = false;
        draft.commitSuccess = false;
        break;
      case FIELD_LIST_UNMOUNT:
        return initialState;
      case FIELD_FORM_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

function formatFields(fields) {
  /* eslint-disable no-return-assign */

  /* Format fields to hash by id:
   *   { <id>: { name: field_01, ... } }
   */
  return fields.reduce((map, field) => {
    map[field.id] = field;
    return map;
  }, {});
}

export default fieldsReducer;
