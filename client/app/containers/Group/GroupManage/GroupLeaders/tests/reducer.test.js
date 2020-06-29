import produce from 'immer';
import {
  getGroupLeadersSuccess,
  getGroupLeaderSuccess
} from 'containers/Group/GroupManage/GroupLeaders/actions';
import groupLeaderReducer from 'containers/Group/GroupManage/GroupLeaders/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('groupLeaderReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isCommitting: false,
      isFormLoading: true,
      groupLeaderList: [],
      groupLeaderTotal: null,
      isFetchingGroupLeaders: true,
      currentGroupLeader: null,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(groupLeaderReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getGroupLeadersSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.groupLeaderList = { id: 4, name: 'dummy' };
      draft.groupLeaderTotal = 31;
      draft.isFetchingGroupLeaders = false;
    });

    expect(
      groupLeaderReducer(
        state,
        getGroupLeadersSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getGroupLeaderSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentGroupLeader = { id: 4, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      groupLeaderReducer(
        state,
        getGroupLeaderSuccess({
          group_leader: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
