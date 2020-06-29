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
  RESET_BUDGET_BEGIN,
  RESET_BUDGET_SUCCESS,
  RESET_BUDGET_ERROR,
  CARRY_BUDGET_BEGIN,
  CARRY_BUDGET_SUCCESS,
  CARRY_BUDGET_ERROR,
  GROUP_LIST_UNMOUNT,
  GROUP_FORM_UNMOUNT,
  JOIN_GROUP_BEGIN,
  JOIN_GROUP_SUCCESS,
  JOIN_GROUP_ERROR,
  LEAVE_GROUP_BEGIN,
  LEAVE_GROUP_SUCCESS,
  LEAVE_GROUP_ERROR,
  GROUP_CATEGORIZE_UNMOUNT,
  GROUP_CATEGORIZE_BEGIN,
  GROUP_CATEGORIZE_SUCCESS,
  GROUP_CATEGORIZE_ERROR,
  JOIN_SUBGROUPS_BEGIN,
  JOIN_SUBGROUPS_SUCCESS,
  JOIN_SUBGROUPS_ERROR
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
  resetBudgetBegin,
  resetBudgetSuccess,
  resetBudgetError,
  carryBudgetBegin,
  carryBudgetError,
  carryBudgetSuccess,
  groupListUnmount,
  groupFormUnmount,
  joinGroupBegin,
  joinGroupSuccess,
  joinGroupError,
  leaveGroupBegin,
  leaveGroupError,
  leaveGroupSuccess,
  groupCategorizeUnmount,
  groupCategorizeBegin,
  groupCategorizeError,
  groupCategorizeSuccess,
  joinSubgroupsBegin,
  joinSubgroupsError,
  joinSubgroupsSuccess
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

    describe('resetBudgetBegin', () => {
      it('has a type of RESET_BUDGET_BEGIN and sets a given payload', () => {
        const expected = {
          type: RESET_BUDGET_BEGIN,
          payload: { value: 709 }
        };

        expect(resetBudgetBegin({ value: 709 })).toEqual(expected);
      });
    });

    describe('resetBudgetSuccess', () => {
      it('has a type of RESET_BUDGET_SUCCESS and sets a given payload', () => {
        const expected = {
          type: RESET_BUDGET_SUCCESS,
          payload: { value: 703 }
        };

        expect(resetBudgetSuccess({ value: 703 })).toEqual(expected);
      });
    });

    describe('resetBudgetError', () => {
      it('has a type of RESET_BUDGET_ERROR and sets a given error', () => {
        const expected = {
          type: RESET_BUDGET_ERROR,
          error: { value: 701 }
        };

        expect(resetBudgetError({ value: 701 })).toEqual(expected);
      });
    });

    describe('carryBudgetBegin', () => {
      it('has a type of CARRY_BUDGET_BEGIN and sets a given payload', () => {
        const expected = {
          type: CARRY_BUDGET_BEGIN,
          payload: { value: 702 }
        };

        expect(carryBudgetBegin({ value: 702 })).toEqual(expected);
      });
    });

    describe('carryBudgetSuccess', () => {
      it('has a type of CARRY_BUDGET_SUCCESS and sets a given payload', () => {
        const expected = {
          type: CARRY_BUDGET_SUCCESS,
          payload: { value: 231 }
        };

        expect(carryBudgetSuccess({ value: 231 })).toEqual(expected);
      });
    });

    describe('carryBudgetError', () => {
      it('has a type of CARRY_BUDGET_ERROR and sets a given error', () => {
        const expected = {
          type: CARRY_BUDGET_ERROR,
          error: { value: 111 }
        };

        expect(carryBudgetError({ value: 111 })).toEqual(expected);
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

    describe('groupCategorizeBegin', () => {
      it('has a type of GROUP_CATEGORIZE_BEGIN and sets a given payload', () => {
        const expected = {
          type: GROUP_CATEGORIZE_BEGIN,
          payload: { value: 49 }
        };

        expect(groupCategorizeBegin({ value: 49 })).toEqual(expected);
      });
    });

    describe('groupCategorizeSuccess', () => {
      it('has a type of GROUP_CATEGORIZE_SUCCESS and sets a given payload', () => {
        const expected = {
          type: GROUP_CATEGORIZE_SUCCESS,
          payload: { value: 777 }
        };

        expect(groupCategorizeSuccess({ value: 777 })).toEqual(expected);
      });
    });

    describe('groupCategorizeError', () => {
      it('has a type of GROUP_CATEGORIZE_ERROR and sets a given error', () => {
        const expected = {
          type: GROUP_CATEGORIZE_ERROR,
          error: { value: 666 }
        };

        expect(groupCategorizeError({ value: 666 })).toEqual(expected);
      });
    });

    describe('groupCategorizeUnmount', () => {
      it('has a type of GROUP_CATEGORIZE_UNMOUNT', () => {
        const expected = {
          type: GROUP_CATEGORIZE_UNMOUNT,
        };

        expect(groupCategorizeUnmount()).toEqual(expected);
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

  describe('group join and leave actions', () => {
    describe('joinGroupBegin', () => {
      it('has a type of JOIN_GROUP_BEGIN and sets a given payload', () => {
        const expected = {
          type: JOIN_GROUP_BEGIN,
          payload: { value: 31 }
        };

        expect(joinGroupBegin({ value: 31 })).toEqual(expected);
      });
    });

    describe('joinGroupSuccess', () => {
      it('has a type of JOIN_GROUP_SUCCESS and sets a given payload', () => {
        const expected = {
          type: JOIN_GROUP_SUCCESS,
          payload: { value: 33 }
        };

        expect(joinGroupSuccess({ value: 33 })).toEqual(expected);
      });
    });

    describe('joinGroupError', () => {
      it('has a type of JOIN_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: JOIN_GROUP_ERROR,
          error: { value: 35 }
        };

        expect(joinGroupError({ value: 35 })).toEqual(expected);
      });
    });

    describe('leaveGroupBegin', () => {
      it('has a type of LEAVE_GROUP_BEGIN and sets a given payload', () => {
        const expected = {
          type: LEAVE_GROUP_BEGIN,
          payload: { value: 41 }
        };

        expect(leaveGroupBegin({ value: 41 })).toEqual(expected);
      });
    });

    describe('leaveGroupSuccess', () => {
      it('has a type of LEAVE_GROUP_SUCCESS and sets a given payload', () => {
        const expected = {
          type: LEAVE_GROUP_SUCCESS,
          payload: { value: 42 }
        };

        expect(leaveGroupSuccess({ value: 42 })).toEqual(expected);
      });
    });

    describe('leaveGroupError', () => {
      it('has a type of LEAVE_GROUP_ERROR and sets a given error', () => {
        const expected = {
          type: LEAVE_GROUP_ERROR,
          error: { value: 43 }
        };

        expect(leaveGroupError({ value: 43 })).toEqual(expected);
      });
    });

    describe('joinSubgroupsBegin', () => {
      it('has a type of JOIN_SUBGROUPS_BEGIN and sets a given payload', () => {
        const expected = {
          type: JOIN_SUBGROUPS_BEGIN,
          payload: { value: 45 }
        };

        expect(joinSubgroupsBegin({ value: 45 })).toEqual(expected);
      });
    });

    describe('joinSubgroupsSuccess', () => {
      it('has a type of JOIN_SUBGROUPS_SUCCESS and sets a given payload', () => {
        const expected = {
          type: JOIN_SUBGROUPS_SUCCESS,
          payload: { value: 46 }
        };

        expect(joinSubgroupsSuccess({ value: 46 })).toEqual(expected);
      });
    });

    describe('joinSubgroupsError', () => {
      it('has a type of JOIN_SUBGROUPS_ERROR and sets a given error', () => {
        const expected = {
          type: JOIN_SUBGROUPS_ERROR,
          error: { value: 48 }
        };

        expect(joinSubgroupsError({ value: 48 })).toEqual(expected);
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
