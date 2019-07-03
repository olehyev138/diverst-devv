import {
  GET_GROUPS_BEGIN, GET_GROUPS_SUCCESS, GET_GROUPS_ERROR,
  GET_GROUP_BEGIN, GET_GROUP_SUCCESS, GET_GROUP_ERROR,
  CREATE_GROUP_BEGIN, CREATE_GROUP_SUCCESS, CREATE_GROUP_ERROR,
  UPDATE_GROUP_BEGIN, UPDATE_GROUP_SUCCESS, UPDATE_GROUP_ERROR,
  DELETE_GROUP_BEGIN, DELETE_GROUP_SUCCESS, DELETE_GROUP_ERROR,
  GROUP_LIST_UNMOUNT, GROUP_FORM_UNMOUNT
} from 'containers/Group/constants';

import {
  getGroupsBegin, getGroupsSuccess, getGroupsError,
  getGroupBegin, getGroupSuccess, getGroupError,
  createGroupBegin, createGroupSuccess, createGroupError,
  updateGroupBegin, updateGroupSuccess, updateGroupError,
  deleteGroupBegin, deleteGroupSuccess, deleteGroupError,
  groupListUnmount, groupFormUnmount
} from 'containers/Group/actions';

describe('Group actions', () => {
  describe('Group list actions', () => {
    describe('getGroupsBegin', () => {
      it('has a type of GET_GROUPS_BEGIN', () => {
        const expected = {
          type: GET_GROUPS_BEGIN,
        };

        expect(getGroupsBegin()).toEqual(expected);
      });
    });

    describe('getGroupsSuccess', () => {
      it('has a type of GET_GROUPS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_GROUPS_SUCCESS,
          payload: { items: {} }
        };

        expect(getGroupsSuccess({ items: { } })).toEqual(expected);
      });
    });

    describe('getGroupsError', () => {
      it('has a type of GET_GROUPS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_GROUPS_ERROR,
          error: 'error'
        };

        expect(getGroupsError('error')).toEqual(expected);
      });
    });
  });

  describe('Group getting actions', () => {
    describe('getGroupBegin', () => {
      it('has a type of GET_GROUP_BEGIN', () => {
        const expected = {
          type: GET_GROUP_BEGIN,
        };

        expect(getGroupBegin()).toEqual(expected);
      });
    });

    describe('getGroupSuccess', () => {
      it('has a type of GET_GROUPS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_GROUP_SUCCESS,
          payload: {}
        };

        expect(getGroupSuccess({})).toEqual(expected);
      });
    });

    describe('getGroupError', () => {
      it('has a type of GET_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: GET_GROUP_ERROR,
          error: 'error'
        };

        expect(getGroupError('error')).toEqual(expected);
      });
    });
  });

  describe('Group creating actions', () => {
    describe('createGroupBegin', () => {
      it('has a type of CREATE_GROUP_BEGIN', () => {
        const expected = {
          type: CREATE_GROUP_BEGIN,
        };

        expect(createGroupBegin()).toEqual(expected);
      });
    });

    describe('createGroupSuccess', () => {
      it('has a type of CREATE_GROUPS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_GROUP_SUCCESS,
          payload: {}
        };

        expect(createGroupSuccess({})).toEqual(expected);
      });
    });

    describe('createGroupError', () => {
      it('has a type of CREATE_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_GROUP_ERROR,
          error: 'error'
        };

        expect(createGroupError('error')).toEqual(expected);
      });
    });
  });

  describe('Group updating actions', () => {
    describe('updateGroupBegin', () => {
      it('has a type of UPDATE_GROUP_BEGIN', () => {
        const expected = {
          type: UPDATE_GROUP_BEGIN,
        };

        expect(updateGroupBegin()).toEqual(expected);
      });
    });

    describe('updateGroupSuccess', () => {
      it('has a type of UPDATE_GROUPS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_GROUP_SUCCESS,
          payload: {}
        };

        expect(updateGroupSuccess({})).toEqual(expected);
      });
    });

    describe('updateGroupError', () => {
      it('has a type of UPDATE_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_GROUP_ERROR,
          error: 'error'
        };

        expect(updateGroupError('error')).toEqual(expected);
      });
    });
  });

  describe('Group updating actions', () => {
    describe('deleteGroupBegin', () => {
      it('has a type of DELETE_GROUP_BEGIN', () => {
        const expected = {
          type: DELETE_GROUP_BEGIN,
        };

        expect(deleteGroupBegin()).toEqual(expected);
      });
    });

    describe('deleteGroupSuccess', () => {
      it('has a type of DELETE_GROUPS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DELETE_GROUP_SUCCESS,
          payload: {}
        };

        expect(deleteGroupSuccess({})).toEqual(expected);
      });
    });

    describe('deleteGroupError', () => {
      it('has a type of DELETE_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: DELETE_GROUP_ERROR,
          error: 'error'
        };

        expect(deleteGroupError('error')).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('groupListUnmount', () => {
      it('has a type of GROUP_LIST_UNMOUNT', () => {
        const expected = {
          type: GROUP_LIST_UNMOUNT
        };

        expect(groupListUnmount()).toEqual(expected);
      });
    });

    describe('groupFormUnmount', () => {
      it('has a type of GROUP_FORM_UNMOUNT', () => {
        const expected = {
          type: GROUP_FORM_UNMOUNT
        };

        expect(groupFormUnmount()).toEqual(expected);
      });
    });
  });
});
