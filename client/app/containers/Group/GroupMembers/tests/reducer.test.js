import produce from 'immer';
import {
  getMembersSuccess,
} from 'containers/Group/GroupMembers/actions';
import membersReducer from 'containers/Group/GroupMembers/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('membersReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isCommitting: false,
      memberList: [],
      memberTotal: null,
      isFetchingMembers: true
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(budgetItemReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getMembersSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.memberList = { id: 4, name: 'dummy' };
      draft.memberTotal = 31;
      draft.isFetchingMembers = false;
    });

    expect(
      membersReducer(
        state,
        getMembersSuccess({
          items: { id: 4, name: 'dummy' },
          total: 31,
        })
      )
    ).toEqual(expected);
  });
});
