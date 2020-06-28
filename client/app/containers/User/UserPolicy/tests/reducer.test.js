import produce from 'immer';
import {
  getPoliciesSuccess,
  getPolicySuccess
} from '../actions';
import policyReducer from 'containers/User/UserPolicy/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('policyReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      policyList: [],
      policyListTotal: null,
      currentPolicy: null,
      isFetchingPolicies: true,
      isFetchingPolicy: true,
      isCommitting: false,
      hasChanged: false,
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(policyReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getUserRolesSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.policyList = [{ id: 4, name: 'dummy' }];
      draft.policyListTotal = 31;
      draft.isFetchingPolicies = false;
    });

    expect(
      policyReducer(
        state,
        getPoliciesSuccess({
          items: [{ id: 4, name: 'dummy' }],
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getPolicySuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentPolicy = { id: 4, name: 'dummy' };
      draft.isFetchingPolicy = false;
    });

    expect(
      policyReducer(
        state,
        getPolicySuccess({
          policy_group_template: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
