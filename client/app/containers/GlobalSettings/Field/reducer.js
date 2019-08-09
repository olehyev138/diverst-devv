/*
 *
 * Field reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_FIELDS_SUCCESS, GET_FIELD_SUCCESS,
  FIELD_LIST_UNMOUNT, FIELD_FORM_UNMOUNT
} from 'containers/GlobalSettings/Field/constants';

export const initialState = {
  fieldList: {},
  fieldTotal: null,
  currentField: null,
};

/* eslint-disable default-case, no-param-reassign */
function fieldsReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_FIELDS_SUCCESS:
        draft.fieldList = formatFields(action.payload.items);
        draft.fieldTotal = action.payload.total;
        break;
      case GET_FIELD_SUCCESS:
        draft.currentField = action.payload.field;
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
