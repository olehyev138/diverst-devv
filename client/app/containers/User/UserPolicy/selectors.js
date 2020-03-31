import { createSelector } from 'reselect/lib';
import { initialState } from './reducer';

const selectPolicyDomain = state => state.policies || initialState;

const selectPaginatedPolicies = () => createSelector(
  selectPolicyDomain,
  policyState => policyState.policyList
);

const selectPoliciesTotal = () => createSelector(
  selectPolicyDomain,
  policyState => policyState.policyListTotal
);

const selectPolicy = () => createSelector(
  selectPolicyDomain,
  policyState => policyState.currentPolicy
);

const selectIsFetchingPolicies = () => createSelector(
  selectPolicyDomain,
  policyState => policyState.isFetchingPolicies
);

const selectIsFetchingPolicy = () => createSelector(
  selectPolicyDomain,
  policyState => policyState.isFetchingPolicy
);

const selectIsCommitting = () => createSelector(
  selectPolicyDomain,
  policyState => policyState.isCommitting
);

const selectHasChanged = () => createSelector(
  selectPolicyDomain,
  policyState => policyState.hasChanged
);

export {
  selectPolicyDomain,
  selectPaginatedPolicies,
  selectPoliciesTotal,
  selectPolicy,
  selectIsFetchingPolicies,
  selectIsFetchingPolicy,
  selectIsCommitting,
  selectHasChanged,
};
