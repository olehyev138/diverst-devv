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
} from '../constants';

import {
  getPolicyBegin,
  getPolicyError,
  getPolicySuccess,
  getPoliciesBegin,
  getPoliciesError,
  getPoliciesSuccess,
  createPolicyBegin,
  createPolicyError,
  createPolicySuccess,
  updatePolicyBegin,
  updatePolicyError,
  updatePolicySuccess,
  deletePolicyBegin,
  deletePolicyError,
  deletePolicySuccess,
  policiesUnmount
} from '../actions';

describe('policy actions', () => {
  describe('getPolicyBegin', () => {
    it('has a type of GET_POLICY_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_POLICY_BEGIN,
        payload: { value: 118 }
      };

      expect(getPolicyBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPolicySuccess', () => {
    it('has a type of GET_POLICY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_POLICY_SUCCESS,
        payload: { value: 865 }
      };

      expect(getPolicySuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getPolicyError', () => {
    it('has a type of GET_POLICY_ERROR and sets a given error', () => {
      const expected = {
        type: GET_POLICY_ERROR,
        error: { value: 709 }
      };

      expect(getPolicyError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getPoliciesBegin', () => {
    it('has a type of GET_POLICIES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_POLICIES_BEGIN,
        payload: { value: 118 }
      };

      expect(getPoliciesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPoliciesSuccess', () => {
    it('has a type of GET_POLICIES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_POLICIES_SUCCESS,
        payload: { value: 118 }
      };

      expect(getPoliciesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getPoliciesError', () => {
    it('has a type of GET_POLICIES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_POLICIES_ERROR,
        error: { value: 709 }
      };

      expect(getPoliciesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createPolicyBegin', () => {
    it('has a type of CREATE_POLICY_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_POLICY_BEGIN,
        payload: { value: 118 }
      };

      expect(createPolicyBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createPolicySuccess', () => {
    it('has a type of CREATE_POLICY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_POLICY_SUCCESS,
        payload: { value: 118 }
      };

      expect(createPolicySuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createPolicyError', () => {
    it('has a type of CREATE_POLICY_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_POLICY_ERROR,
        error: { value: 709 }
      };

      expect(createPolicyError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updatePolicyBegin', () => {
    it('has a type of UPDATE_POLICY_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_POLICY_BEGIN,
        payload: { value: 118 }
      };

      expect(updatePolicyBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updatePolicySuccess', () => {
    it('has a type of UPDATE_POLICY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_POLICY_SUCCESS,
        payload: { value: 118 }
      };

      expect(updatePolicySuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updatePolicyError', () => {
    it('has a type of UPDATE_POLICY_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_POLICY_ERROR,
        error: { value: 709 }
      };

      expect(updatePolicyError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deletePolicyBegin', () => {
    it('has a type of DELETE_POLICY_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_POLICY_BEGIN,
        payload: { value: 118 }
      };

      expect(deletePolicyBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deletePolicySuccess', () => {
    it('has a type of DELETE_POLICY_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_POLICY_SUCCESS,
        payload: { value: 118 }
      };

      expect(deletePolicySuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deletePolicyError', () => {
    it('has a type of DELETE_POLICY_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_POLICY_ERROR,
        error: { value: 709 }
      };

      expect(deletePolicyError({ value: 709 })).toEqual(expected);
    });
  });

  describe('policyUnmount', () => {
    it('has a type of POLICIES_UNMOUNT', () => {
      const expected = {
        type: POLICIES_UNMOUNT,
      };

      expect(policiesUnmount()).toEqual(expected);
    });
  });
});
