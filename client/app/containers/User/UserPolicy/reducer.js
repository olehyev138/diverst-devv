/*
 *
 * Policy reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_POLICY_BEGIN,
  GET_POLICY_SUCCESS,
  GET_POLICY_ERROR,
  GET_POLICIES_BEGIN,
  GET_POLICIES_SUCCESS,
  GET_POLICIES_ERROR,
  CREATE_POLICY_BEGIN,
  CREATE_POLICY_SUCCESS,
  CREATE_POLICY_ERROR,
  UPDATE_POLICY_BEGIN,
  UPDATE_POLICY_SUCCESS,
  UPDATE_POLICY_ERROR,
  DELETE_POLICY_BEGIN,
  DELETE_POLICY_SUCCESS,
  DELETE_POLICY_ERROR,
  POLICIES_UNMOUNT,
} from './constants';

export const initialState = {
  policyList: [],
  policyListTotal: null,
  currentPolicy: null,
  isFetchingPolicies: true,
  isFetchingPolicy: true,
  isCommitting: false,
  hasChanged: false,
};

/* eslint-disable-next-line default-case, no-param-reassign */
function policyReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_POLICY_BEGIN:
        draft.isFetchingPolicy = true;
        break;

      case GET_POLICY_SUCCESS:
        draft.currentPolicy = action.payload.policy_group_template;
        draft.isFetchingPolicy = false;
        break;

      case GET_POLICY_ERROR:
        draft.isFetchingPolicy = false;
        break;

      case GET_POLICIES_BEGIN:
        draft.isFetchingPolicies = true;
        draft.hasChanged = false;
        break;

      case GET_POLICIES_SUCCESS:
        draft.policyList = action.payload.items;
        draft.policyListTotal = action.payload.total;
        draft.isFetchingPolicies = false;
        break;

      case GET_POLICIES_ERROR:
        draft.isFetchingPolicies = false;
        break;

      case CREATE_POLICY_BEGIN:
      case UPDATE_POLICY_BEGIN:
      case DELETE_POLICY_BEGIN:
        draft.isCommitting = true;
        draft.hasChanged = false;
        break;

      case CREATE_POLICY_SUCCESS:
      case UPDATE_POLICY_SUCCESS:
      case DELETE_POLICY_SUCCESS:
        draft.isCommitting = false;
        draft.hasChanged = true;
        break;

      case CREATE_POLICY_ERROR:
      case UPDATE_POLICY_ERROR:
      case DELETE_POLICY_ERROR:
        draft.isCommitting = false;
        break;

      case POLICIES_UNMOUNT:
        return initialState;
    }
  });
}
export default policyReducer;
