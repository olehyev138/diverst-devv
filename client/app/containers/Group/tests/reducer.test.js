import produce from 'immer';
import groupsReducer from 'containers/Group/reducer';
import {
  getGroupsSuccess, getGroupSuccess,
  groupAllUnmount, groupFormUnmount
} from 'containers/Group/actions';

/* eslint-disable default-case, no-param-reassign */
describe('groupsReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoading: true,
      isColorGroupsLoading: true,
      isFormLoading: true,
      isCommitting: false,
      groupColorList: [],
      groupList: [],
      groupTotal: null,
      currentGroup: null,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(groupsReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getGroupsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.groupList = [{ id: 37, name: 'dummy' }];
      draft.groupTotal = 49;
      draft.isLoading = false;
    });

    expect(
      groupsReducer(
        state,
        getGroupsSuccess({
          items: [{ id: 37, name: 'dummy' }],
          total: 49,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGroupSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentGroup = { id: 37, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      groupsReducer(
        state,
        getGroupSuccess({ group: { id: 37, name: 'dummy' } })
      )
    ).toEqual(expected);
  });

  it('handles the groupAllUnmount action correctly', () => {
    const expected = state;

    expect(groupsReducer(state, groupAllUnmount())).toEqual(expected);
  });

  it('handles the groupFormUnmount action correctly', () => {
    const expected = state;

    expect(groupsReducer(state, groupFormUnmount())).toEqual(expected);
  });
});
