import {
  selectPillarDomain,
  selectPaginatedPillars,
  selectPillarsTotal,
  selectPillar,
  selectIsFetchingPillars,
  selectIsFetchingPillar,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

import { initialState } from '../reducer';

describe('Pillar selectors', () => {
  describe('selectPillarDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { pillars: { pillar: {} } };
      const selected = selectPillarDomain(mockedState);

      expect(selected).toEqual({ pillar: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectPillarDomain(mockedState);

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

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectPillarsTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { pillarListTotal: 289 };
      const selected = selectPillarsTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingPillar', () => {
    it('should select the \'is fetchingPillar\' flag', () => {
      const mockedState = { isFetchingPillar: true };
      const selected = selectIsFetchingPillar().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingPillars', () => {
    it('should select the \'is fetchingPillars\' flag', () => {
      const mockedState = { isFetchingPillars: true };
      const selected = selectIsFetchingPillars().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectPillar', () => {
    it('should select the currentPillar', () => {
      const mockedState = { currentPillar: { id: 374, __dummy: '374' } };
      const selected = selectPillar().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedPillars', () => {
    it('should select the paginated pillars', () => {
      const mockedState = { pillarList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedPillars().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });
});
