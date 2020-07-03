import {
  GET_GROUP_LEADER_BEGIN,
  GET_GROUP_LEADER_SUCCESS,
  GET_GROUP_LEADER_ERROR,
  GET_GROUP_LEADERS_BEGIN,
  GET_GROUP_LEADERS_SUCCESS,
  GET_GROUP_LEADERS_ERROR,
  CREATE_GROUP_LEADER_BEGIN,
  CREATE_GROUP_LEADER_SUCCESS,
  CREATE_GROUP_LEADER_ERROR,
  UPDATE_GROUP_LEADER_BEGIN,
  UPDATE_GROUP_LEADER_SUCCESS,
  UPDATE_GROUP_LEADER_ERROR,
  DELETE_GROUP_LEADER_BEGIN,
  DELETE_GROUP_LEADER_SUCCESS,
  DELETE_GROUP_LEADER_ERROR,
  GROUP_LEADERS_UNMOUNT,
} from '../constants';

import {
  getGroupLeaderBegin,
  getGroupLeaderError,
  getGroupLeaderSuccess,
  getGroupLeadersBegin,
  getGroupLeadersError,
  getGroupLeadersSuccess,
  createGroupLeaderBegin,
  createGroupLeaderError,
  createGroupLeaderSuccess,
  updateGroupLeaderBegin,
  updateGroupLeaderError,
  updateGroupLeaderSuccess,
  deleteGroupLeaderBegin,
  deleteGroupLeaderError,
  deleteGroupLeaderSuccess,
  groupLeadersUnmount
} from '../actions';

describe('pillar actions', () => {
  describe('getGroupLeaderBegin', () => {
    it('has a type of GET_GROUP_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(getGroupLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupLeaderSuccess', () => {
    it('has a type of GET_GROUP_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_LEADER_SUCCESS,
        payload: { value: 865 }
      };

      expect(getGroupLeaderSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getGroupLeaderError', () => {
    it('has a type of GET_GROUP_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROUP_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(getGroupLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getGroupLeadersBegin', () => {
    it('has a type of GET_GROUP_LEADERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_LEADERS_BEGIN,
        payload: { value: 118 }
      };

      expect(getGroupLeadersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupLeadersSuccess', () => {
    it('has a type of GET_GROUP_LEADERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_GROUP_LEADERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getGroupLeadersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getGroupLeadersError', () => {
    it('has a type of GET_GROUP_LEADERS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_GROUP_LEADERS_ERROR,
        error: { value: 709 }
      };

      expect(getGroupLeadersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createGroupLeaderBegin', () => {
    it('has a type of CREATE_GROUP_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_GROUP_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(createGroupLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createGroupLeaderSuccess', () => {
    it('has a type of CREATE_GROUP_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_GROUP_LEADER_SUCCESS,
        payload: { value: 118 }
      };

      expect(createGroupLeaderSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createGroupLeaderError', () => {
    it('has a type of CREATE_GROUP_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_GROUP_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(createGroupLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateGroupLeaderBegin', () => {
    it('has a type of UPDATE_GROUP_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_GROUP_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(updateGroupLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateGroupLeaderSuccess', () => {
    it('has a type of UPDATE_GROUP_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_GROUP_LEADER_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateGroupLeaderSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateGroupLeaderError', () => {
    it('has a type of UPDATE_GROUP_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_GROUP_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(updateGroupLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteGroupLeaderBegin', () => {
    it('has a type of DELETE_GROUP_LEADER_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_GROUP_LEADER_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteGroupLeaderBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteGroupLeaderSuccess', () => {
    it('has a type of DELETE_GROUP_LEADER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_GROUP_LEADER_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteGroupLeaderSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteGroupLeaderError', () => {
    it('has a type of DELETE_GROUP_LEADER_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_GROUP_LEADER_ERROR,
        error: { value: 709 }
      };

      expect(deleteGroupLeaderError({ value: 709 })).toEqual(expected);
    });
  });

  describe('pillarsUnmount', () => {
    it('has a type of GROUP_LEADERS_UNMOUNT', () => {
      const expected = {
        type: GROUP_LEADERS_UNMOUNT,
      };

      expect(groupLeadersUnmount()).toEqual(expected);
    });
  });
});
