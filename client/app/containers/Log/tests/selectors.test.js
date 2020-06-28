import {
  selectPaginatedLogs,
  selectLogsDomain,
  selectLogTotal,
  selectIsLoading
} from '../selectors';

import { initialState } from '../reducer';

describe('Logs selectors', () => {
  describe('selectArchivesDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { logs: { log: {} } };
      const selected = selectLogsDomain(mockedState);

      expect(selected).toEqual({ log: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectLogsDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectLogTotal', () => {
    it('should select the log total', () => {
      const mockedState = { logTotal: 289 };
      const selected = selectLogTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectLogIsLoading', () => {
    it('should select the archive is loading', () => {
      const mockedState = { isLoading: { id: 422, __dummy: '422' } };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual({ id: 422, __dummy: '422' });
    });
  });
});
