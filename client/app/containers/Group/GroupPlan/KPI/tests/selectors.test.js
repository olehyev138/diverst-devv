import {
  selectUpdateDomain,
  selectPaginatedUpdates,
  selectUpdateTotal,
  selectUpdate,
  selectIsFetchingUpdates,
  selectIsFetchingKpi,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';
import { initialState } from '../reducer';

describe('Kpi selectors', () => {
  describe('selectUpdateDomain', () => {
    it('should select the update domain', () => {
      const mockedState = { updates: { update: {} } };
      const selected = selectUpdateDomain(mockedState);

      expect(selected).toEqual({ update: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectUpdateDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectPaginatedUpdates', () => {
    it('should select the paginated updates', () => {
      const mockedState = { updateList: { id: 884, __dummy: '884' } };
      const selected = selectPaginatedUpdates().resultFunc(mockedState);

      expect(selected).toEqual({ id: 884, __dummy: '884' });
    });
  });

  describe('selectUpdateTotal', () => {
    it('should select the update total', () => {
      const mockedState = { updateListTotal: 280 };
      const selected = selectUpdateTotal().resultFunc(mockedState);

      expect(selected).toEqual(280);
    });
  });

  describe('selectUpdate', () => {
    it('should select the update', () => {
      const mockedState = { currentUpdate: { id: 661, __dummy: '661' } };
      const selected = selectUpdate().resultFunc(mockedState);

      expect(selected).toEqual({ id: 661, __dummy: '661' });
    });
  });

  describe('selectIsFetchingUpdates', () => {
    it('should select the \'is fetching updates\' flag', () => {
      const mockedState = { isFetchingUpdates: false };
      const selected = selectIsFetchingUpdates().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsFetchingKpi', () => {
    it('should select the \'is fetching kpi\' flag', () => {
      const mockedState = { isFetchingUpdate: false };
      const selected = selectIsFetchingKpi().resultFunc(mockedState);

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

  describe('selectHasChanged', () => {
    it('should select the \'has changed\' flag', () => {
      const mockedState = { hasChanged: false };
      const selected = selectHasChanged().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
