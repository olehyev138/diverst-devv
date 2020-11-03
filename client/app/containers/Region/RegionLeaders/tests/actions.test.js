import {
  GET_REGION_LEADER_BEGIN,
  GET_REGION_LEADER_SUCCESS,
  GET_REGION_LEADER_ERROR,
  GET_REGION_LEADERS_BEGIN,
  GET_REGION_LEADERS_SUCCESS,
  GET_REGION_LEADERS_ERROR,
  CREATE_REGION_LEADER_BEGIN,
  CREATE_REGION_LEADER_SUCCESS,
  CREATE_REGION_LEADER_ERROR,
  UPDATE_REGION_LEADER_BEGIN,
  UPDATE_REGION_LEADER_SUCCESS,
  UPDATE_REGION_LEADER_ERROR,
  DELETE_REGION_LEADER_BEGIN,
  DELETE_REGION_LEADER_SUCCESS,
  DELETE_REGION_LEADER_ERROR,
  REGION_LEADERS_UNMOUNT,
} from '../constants';

import {
  getRegionLeaderBegin,
  getRegionLeaderError,
  getRegionLeaderSuccess,
  getRegionLeadersBegin,
  getRegionLeadersError,
  getRegionLeadersSuccess,
  createRegionLeaderBegin,
  createRegionLeaderError,
  createRegionLeaderSuccess,
  updateRegionLeaderBegin,
  updateRegionLeaderError,
  updateRegionLeaderSuccess,
  deleteRegionLeaderBegin,
  deleteRegionLeaderError,
  deleteRegionLeaderSuccess,
  regionLeadersUnmount
} from '../actions';

describe('pillar actions', () => {
  describe('getRegionLeaderBegin', () => {
    it('has a type of GET_REGION_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_REGION_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(getRegionLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getRegionLeaderSuccess', () => {
    it('has a type of GET_REGION_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_REGION_LEADER_SUCCESS,
        payload: { value: 865 }
      };

      expect(getRegionLeaderSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getRegionLeaderError', () => {
    it('has a type of GET_REGION_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: GET_REGION_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(getRegionLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getRegionLeadersBegin', () => {
    it('has a type of GET_REGION_LEADERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_REGION_LEADERS_BEGIN,
        payload: { value: 118 }
      };

      expect(getRegionLeadersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getRegionLeadersSuccess', () => {
    it('has a type of GET_REGION_LEADERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_REGION_LEADERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getRegionLeadersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getRegionLeadersError', () => {
    it('has a type of GET_REGION_LEADERS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_REGION_LEADERS_ERROR,
        error: { value: 709 }
      };

      expect(getRegionLeadersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createRegionLeaderBegin', () => {
    it('has a type of CREATE_REGION_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_REGION_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(createRegionLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createRegionLeaderSuccess', () => {
    it('has a type of CREATE_REGION_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_REGION_LEADER_SUCCESS,
        payload: { value: 118 }
      };

      expect(createRegionLeaderSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createRegionLeaderError', () => {
    it('has a type of CREATE_REGION_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_REGION_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(createRegionLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateRegionLeaderBegin', () => {
    it('has a type of UPDATE_REGION_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_REGION_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(updateRegionLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateRegionLeaderSuccess', () => {
    it('has a type of UPDATE_REGION_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_REGION_LEADER_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateRegionLeaderSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateRegionLeaderError', () => {
    it('has a type of UPDATE_REGION_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_REGION_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(updateRegionLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteRegionLeaderBegin', () => {
    it('has a type of DELETE_REGION_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_REGION_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteRegionLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteRegionLeaderSuccess', () => {
    it('has a type of DELETE_REGION_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_REGION_LEADER_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteRegionLeaderSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteRegionLeaderError', () => {
    it('has a type of DELETE_REGION_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_REGION_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(deleteRegionLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('pillarsUnmount', () => {
    it('has a type of REGION_LEADERS_UNMOUNT', () => {
      const expected = {
        type: REGION_LEADERS_UNMOUNT,
      };

      expect(regionLeadersUnmount()).toEqual(expected);
    });
  });
});
