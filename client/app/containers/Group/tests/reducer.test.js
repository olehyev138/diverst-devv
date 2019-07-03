import produce from 'immer';
import groupsReducer from 'containers/Group/reducer';
import {
  getGroupsSuccess, getGroupSuccess,
  groupListUnmount, groupFormUnmount
} from 'containers/Group/actions';

/* eslint-disable default-case, no-param-reassign */
describe('groupsReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      groupList: {},
      groupTotal: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(groupsReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getGroupsSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.groupList = { 37: { id: 37, name: 'dummy' } };
      draft.groupTotal = 49;
    });

    expect(
      groupsReducer(
        state,
        getGroupsSuccess({
          items: [{ id: 37, name: 'dummy' }],
          total: 49
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGroupSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.groupList = { 37: { id: 37, name: 'dummy' } };
    });

    expect(
      groupsReducer(
        state,
        getGroupSuccess({
          group: { id: 37, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });

  it('handles the groupListUnmount action correctly', () => {
    const expected = produce(state, draft => state);

    expect(groupsReducer(state, groupListUnmount())).toEqual(expected);
  });

  it('handles the groupFormUnmount action correctly', () => {
    const expected = produce(state, draft => state);

    expect(groupsReducer(state, groupFormUnmount())).toEqual(expected);
  });
});
