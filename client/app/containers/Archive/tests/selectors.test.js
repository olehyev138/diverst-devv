import {
  selectArchives,
  selectArchivesTotal,
  selectArchivesDomain,
  selectHasChanged,
  selectIsLoading
} from '../selectors';

import { initialState } from '../reducer';

describe('Archiving selectors', () => {
  describe('selectArchivesDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { archives: { archive: {} } };
      const selected = selectArchivesDomain(mockedState);

      expect(selected).toEqual({ archive: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectArchivesDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectArchiveTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { archivesTotal: 289 };
      const selected = selectArchivesTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectArchiveIsLoading', () => {
    it('should select the archive is loading', () => {
      const mockedState = { isLoading: { id: 422, __dummy: '422' } };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual({ id: 422, __dummy: '422' });
    });
  });
});
