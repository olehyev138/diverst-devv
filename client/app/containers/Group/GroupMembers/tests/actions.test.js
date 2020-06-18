import {
  GET_MEMBERS_BEGIN,
  GET_MEMBERS_SUCCESS,
  GET_MEMBERS_ERROR,
  CREATE_MEMBERS_BEGIN,
  CREATE_MEMBERS_SUCCESS,
  CREATE_MEMBERS_ERROR,
  UPDATE_MEMBER_BEGIN,
  UPDATE_MEMBER_SUCCESS,
  UPDATE_MEMBER_ERROR,
  DELETE_MEMBER_BEGIN,
  DELETE_MEMBER_SUCCESS,
  DELETE_MEMBER_ERROR,
  EXPORT_MEMBERS_BEGIN,
  EXPORT_MEMBERS_ERROR,
  EXPORT_MEMBERS_SUCCESS,
  GROUP_MEMBERS_UNMOUNT,
} from '../constants';

import {
  getMembersBegin,
  getMembersError,
  getMembersSuccess,
  createMembersBegin,
  createMembersError,
  createMembersSuccess,
  updateMemberBegin,
  updateMemberError,
  updateMemberSuccess,
  deleteMemberBegin,
  deleteMemberError,
  deleteMemberSuccess,
  exportMembersBegin,
  exportMembersError,
  exportMembersSuccess,
  groupMembersUnmount
} from '../actions';

describe('member actions', () => {
  describe('getMembersBegin', () => {
    it('has a type of GET_MEMBERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_MEMBERS_BEGIN,
        payload: { value: 118 }
      };

      expect(getMembersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getMembersSuccess', () => {
    it('has a type of GET_MEMBERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_MEMBERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getMembersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getMembersError', () => {
    it('has a type of GET_MEMBERS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_MEMBERS_ERROR,
        error: { value: 709 }
      };

      expect(getMembersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createMemberBegin', () => {
    it('has a type of CREATE_MEMBER_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_MEMBERS_BEGIN,
        payload: { value: 118 }
      };

      expect(createMembersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createMemberSuccess', () => {
    it('has a type of CREATE_MEMBER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_MEMBERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(createMembersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createMemberError', () => {
    it('has a type of CREATE_MEMBER_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_MEMBERS_ERROR,
        error: { value: 709 }
      };

      expect(createMembersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateMemberBegin', () => {
    it('has a type of UPDATE_MEMBER_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_MEMBER_BEGIN,
        payload: { value: 118 }
      };

      expect(updateMemberBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateMemberSuccess', () => {
    it('has a type of UPDATE_MEMBER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_MEMBER_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateMemberSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateMemberError', () => {
    it('has a type of UPDATE_MEMBER_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_MEMBER_ERROR,
        error: { value: 709 }
      };

      expect(updateMemberError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteMemberBegin', () => {
    it('has a type of DELETE_MEMBER_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_MEMBER_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteMemberBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteMemberSuccess', () => {
    it('has a type of DELETE_MEMBER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_MEMBER_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteMemberSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteMemberError', () => {
    it('has a type of DELETE_MEMBER_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_MEMBER_ERROR,
        error: { value: 709 }
      };

      expect(deleteMemberError({ value: 709 })).toEqual(expected);
    });
  });

  describe('exportMemberBegin', () => {
    it('has a type of EXPORT_MEMBER_BEGIN and sets a given payload', () => {
      const expected = {
        type: EXPORT_MEMBERS_BEGIN,
        payload: { value: 118 }
      };

      expect(exportMembersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('exportMemberSuccess', () => {
    it('has a type of EXPORT_MEMBER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: EXPORT_MEMBERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(exportMembersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('exportMemberError', () => {
    it('has a type of EXPORT_MEMBER_ERROR and sets a given error', () => {
      const expected = {
        type: EXPORT_MEMBERS_ERROR,
        error: { value: 709 }
      };

      expect(exportMembersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('groupMembersUnmount', () => {
    it('has a type of GROUP_MEMBERS_UNMOUNT', () => {
      const expected = {
        type: GROUP_MEMBERS_UNMOUNT,
      };

      expect(groupMembersUnmount()).toEqual(expected);
    });
  });
});
