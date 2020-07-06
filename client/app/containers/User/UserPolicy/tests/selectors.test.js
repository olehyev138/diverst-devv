import {
  selectPolicyDomain,
  selectPaginatedPolicies,
  selectPoliciesTotal,
  selectPolicy,
  selectIsFetchingPolicies,
  selectIsFetchingPolicy,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

import { initialState } from '../reducer';

describe('Policy selectors', () => {
  describe('selectPolicyDomain', () => {
    it('should select the policies domain', () => {
      const mockedState = { policies: { policy: {} } };
      const selected = selectPolicyDomain(mockedState);

      expect(selected).toEqual({ policy: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectPolicyDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectPoliciesTotal', () => {
    it('should select the policy total', () => {
      const mockedState = { policyListTotal: 289 };
      const selected = selectPoliciesTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingPolicies', () => {
    it('should select the \'is fetchingPolicies\' flag', () => {
      const mockedState = { isFetchingPolicies: true };
      const selected = selectIsFetchingPolicies().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingPolicy', () => {
    it('should select the \'is isFetchingPolicy\' flag', () => {
      const mockedState = { isFetchingPolicy: true };
      const selected = selectIsFetchingPolicy().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectPolicy', () => {
    it('should select the currentPolicy', () => {
      const mockedState = { currentPolicy: { id: 374, __dummy: '374' } };
      const selected = selectPolicy().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedPolicies', () => {
    it('should select the paginated policies', () => {
      const mockedState = { policyList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedPolicies().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectFormPolicy', () => {
    it('should select currentPolicy and do more stuff', () => {
      const mockedState = { currentPolicy: { id: 374, __dummy: '374' } };
      const selected = selectPolicy().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
