import { selectIsCommitting, selectCustomTextDomain } from '../selectors';

import { initialState } from '../reducer';

describe('Metrics selectors', () => {
  describe('selectMetricsDomain', () => {
    it('should select the metrics domain', () => {
      const mockedState = {};
      const selected = selectCustomTextDomain(mockedState);

      expect(selected).toEqual({ ...initialState });
    });

    it('should select initialState', () => {
      const mockedState = {};
      const selected = selectCustomTextDomain(mockedState);

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
});
