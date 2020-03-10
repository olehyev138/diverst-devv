import {
  GET_GROUPS_BEGIN,
  GET_GROUPS_SUCCESS,
  GET_GROUPS_ERROR,
  GET_ANNUAL_BUDGETS_BEGIN,
  GET_ANNUAL_BUDGETS_SUCCESS,
  GET_ANNUAL_BUDGETS_ERROR,
  GET_GROUP_BEGIN,
  GET_GROUP_SUCCESS,
  GET_GROUP_ERROR,
  CREATE_GROUP_BEGIN,
  CREATE_GROUP_SUCCESS,
  CREATE_GROUP_ERROR,
  UPDATE_GROUP_BEGIN,
  UPDATE_GROUP_SUCCESS,
  UPDATE_GROUP_ERROR,
  UPDATE_GROUP_SETTINGS_BEGIN,
  UPDATE_GROUP_SETTINGS_SUCCESS,
  UPDATE_GROUP_SETTINGS_ERROR,
  DELETE_GROUP_BEGIN,
  DELETE_GROUP_SUCCESS,
  DELETE_GROUP_ERROR,
  GROUP_LIST_UNMOUNT,
  GROUP_FORM_UNMOUNT,
} from '../constants';

import {
  getGroupsBegin,
  getGroupsSuccess,
  getGroupsError,
  getAnnualBudgetsBegin,
  getAnnualBudgetsSuccess,
  getAnnualBudgetsError,
  getGroupBegin,
  getGroupSuccess,
  getGroupError,
  createGroupBegin,
  createGroupSuccess,
  createGroupError,
  updateGroupBegin,
  updateGroupSuccess,
  updateGroupError,
  updateGroupSettingsBegin,
  updateGroupSettingsSuccess,
  updateGroupSettingsError,
  deleteGroupBegin,
  deleteGroupSuccess,
  deleteGroupError,
  groupListUnmount,
  groupFormUnmount,
} from '../actions';

describe('group actions', () => {
  describe('group list actions', () => {
    describe('getGroupsBegin', () => {
      it('has a type of GET_GROUPS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_GROUPS_BEGIN,
          payload: { value: 118 }
        };

        expect(getGroupsBegin({ value: 118 })).toEqual(expected);
      });
    });

    describe('getGroupsSuccess', () => {
      it('has a type of GET_GROUPS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_GROUPS_SUCCESS,
          payload: { value: 91 }
        };

        expect(getGroupsSuccess({ value: 91 })).toEqual(expected);
      });
    });

    describe('getGroupsError', () => {
      it('has a type of GET_GROUPS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_GROUPS_ERROR,
          error: { value: 258 }
        };

        expect(getGroupsError({ value: 258 })).toEqual(expected);
      });
    });
  });

  describe('annual budget list actions', () => {
    describe('getAnnualBudgetsBegin', () => {
      it('has a type of GET_ANNUAL_BUDGETS_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_ANNUAL_BUDGETS_BEGIN,
          payload: { value: 4 }
        };

        expect(getAnnualBudgetsBegin({ value: 4 })).toEqual(expected);
      });
    });

    describe('getAnnualBudgetsSuccess', () => {
      it('has a type of GET_ANNUAL_BUDGETS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_ANNUAL_BUDGETS_SUCCESS,
          payload: { value: 865 }
        };

        expect(getAnnualBudgetsSuccess({ value: 865 })).toEqual(expected);
      });
    });

    describe('getAnnualBudgetsError', () => {
      it('has a type of GET_ANNUAL_BUDGETS_ERROR and sets a given error', () => {
        const expected = {
          type: GET_ANNUAL_BUDGETS_ERROR,
          error: { value: 709 }
        };

        expect(getAnnualBudgetsError({ value: 709 })).toEqual(expected);
      });
    });
  });

  describe('group getting actions', () => {
    describe('getGroupBegin', () => {
      it('has a type of GET_GROUP_BEGIN and sets a given payload', () => {
        const expected = {
          type: GET_GROUP_BEGIN,
          payload: { value: 382 }
        };

        expect(getGroupBegin({ value: 382 })).toEqual(expected);
      });
    });

    describe('getGroupSuccess', () => {
      it('has a type of GET_GROUP_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GET_GROUP_SUCCESS,
          payload: { value: 431 }
        };

        expect(getGroupSuccess({ value: 431 })).toEqual(expected);
      });
    });

    describe('getGroupError', () => {
      it('has a type of GET_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: GET_GROUP_ERROR,
          error: { value: 593 }
        };

        expect(getGroupError({ value: 593 })).toEqual(expected);
      });
    });
  });

  describe('group creating actions', () => {
    describe('createGroupBegin', () => {
      it('has a type of CREATE_GROUP_BEGIN and sets a given payload', () => {
        const expected = {
          type: CREATE_GROUP_BEGIN,
          payload: { value: 519 }
        };

        expect(createGroupBegin({ value: 519 })).toEqual(expected);
      });
    });

    describe('createGroupSuccess', () => {
      it('has a type of CREATE_GROUP_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CREATE_GROUP_SUCCESS,
          payload: { value: 583 }
        };

        expect(createGroupSuccess({ value: 583 })).toEqual(expected);
      });
    });

    describe('createGroupError', () => {
      it('has a type of CREATE_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: CREATE_GROUP_ERROR,
          error: { value: 249 }
        };

        expect(createGroupError({ value: 249 })).toEqual(expected);
      });
    });
  });

  describe('group updating actions', () => {
    describe('updateGroupBegin', () => {
      it('has a type of UPDATE_GROUP_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_GROUP_BEGIN,
          payload: { value: 314 }
        };

        expect(updateGroupBegin({ value: 314 })).toEqual(expected);
      });
    });

    describe('updateGroupSuccess', () => {
      it('has a type of UPDATE_GROUP_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_GROUP_SUCCESS,
          payload: { value: 49 }
        };

        expect(updateGroupSuccess({ value: 49 })).toEqual(expected);
      });
    });

    describe('updateGroupError', () => {
      it('has a type of UPDATE_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_GROUP_ERROR,
          error: { value: 25 }
        };

        expect(updateGroupError({ value: 25 })).toEqual(expected);
      });
    });
  });

  describe('group setting list actions', () => {
    describe('updateGroupSettingsBegin', () => {
      it('has a type of UPDATE_GROUP_SETTINGS_BEGIN and sets a given payload', () => {
        const expected = {
          type: UPDATE_GROUP_SETTINGS_BEGIN,
          payload: { value: 30 }
        };

        expect(updateGroupSettingsBegin({ value: 30 })).toEqual(expected);
      });
    });

    describe('updateGroupSettingsSuccess', () => {
      it('has a type of UPDATE_GROUP_SETTINGS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: UPDATE_GROUP_SETTINGS_SUCCESS,
          payload: { value: 723 }
        };

        expect(updateGroupSettingsSuccess({ value: 723 })).toEqual(expected);
      });
    });

    describe('updateGroupSettingsError', () => {
      it('has a type of UPDATE_GROUP_SETTINGS_ERROR and sets a given error', () => {
        const expected = {
          type: UPDATE_GROUP_SETTINGS_ERROR,
          error: { value: 858 }
        };

        expect(updateGroupSettingsError({ value: 858 })).toEqual(expected);
      });
    });
  });

  describe('group deleting actions', () => {
    describe('deleteGroupBegin', () => {
      it('has a type of DELETE_GROUP_BEGIN and sets a given payload', () => {
        const expected = {
          type: DELETE_GROUP_BEGIN,
          payload: { value: 728 }
        };

        expect(deleteGroupBegin({ value: 728 })).toEqual(expected);
      });
    });

    describe('deleteGroupSuccess', () => {
      it('has a type of DELETE_GROUP_SUCCESS and sets a given payload', () => {
        const expected = {
          type: DELETE_GROUP_SUCCESS,
          payload: { value: 358 }
        };

        expect(deleteGroupSuccess({ value: 358 })).toEqual(expected);
      });
    });

    describe('deleteGroupError', () => {
      it('has a type of DELETE_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: DELETE_GROUP_ERROR,
          error: { value: 853 }
        };

        expect(deleteGroupError({ value: 853 })).toEqual(expected);
      });
    });
  });

  describe('State cleaning actions', () => {
    describe('groupListUnmount', () => {
      it('has a type of GROUP_LIST_UNMOUNT', () => {
        const expected = {
          type: GROUP_LIST_UNMOUNT,
        };

        expect(groupListUnmount()).toEqual(expected);
      });
    });

    describe('groupFormUnmount', () => {
      it('has a type of GROUP_FORM_UNMOUNT', () => {
        const expected = {
          type: GROUP_FORM_UNMOUNT,
        };

        expect(groupFormUnmount()).toEqual(expected);
      });
    });
  });
});
