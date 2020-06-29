import {
  selectPaginatedOutcomes,
  selectOutcomesTotal,
  selectOutcome,
  selectIsCommitting,
  selectIsLoading,
  selectOutcomesDomain,
  selectIsFormLoading
} from '../selectors';

import { initialState } from '../reducer';

describe('Outcome selectors', () => {
  describe('selectOutcomeDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { outcomes: { outcome: {} } };
      const selected = selectOutcomesDomain(mockedState);

      expect(selected).toEqual({ outcome: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectOutcomesDomain(mockedState);

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

  describe('selectIsLoading', () => {
    it('should select the \'is loading\' flag', () => {
      const mockedState = { isLoading: true };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select the \'is formLoading\' flag', () => {
      const mockedState = { isFormLoading: true };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectOutcomesTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { outcomesTotal: 289 };
      const selected = selectOutcomesTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectOutcome', () => {
    it('should select the currentOutcome', () => {
      const mockedState = { currentOutcome: { id: 374, __dummy: '374' } };
      const selected = selectOutcome().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedOutcomes', () => {
    it('should select the paginated outcomes', () => {
      const mockedState = { outcomes: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedOutcomes().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });
});
