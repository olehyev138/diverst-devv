import {
  selectKpiDomain,
  selectPaginatedUpdates,
  selectUpdatesTotal,
  selectUpdate,
  selectIsFetchingUpdates,
  selectIsFetchingUpdate,
  selectIsCommittingUpdate,
  selectHasChangedUpdate,
  selectPaginatedFields,
  selectFieldsTotal,
  selectField,
  selectIsFetchingFields,
  selectIsFetchingField,
  selectIsCommittingField,
  selectHasChangedField,
} from '../selectors';
import { initialState } from '../reducer';

describe('Kpi selectors', () => {
  describe('selectKpiDomain', () => {
    it('should select the kpi domain', () => {
      const mockedState = { kpi: { kpus: {} } };
      const selected = selectKpiDomain(mockedState);

      expect(selected).toEqual({ kpus: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectKpiDomain(mockedState);

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

  describe('selectUpdatesTotal', () => {
    it('should select the updates total', () => {
      const mockedState = { updateListTotal: 568 };
      const selected = selectUpdatesTotal().resultFunc(mockedState);

      expect(selected).toEqual(568);
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

  describe('selectIsFetchingUpdate', () => {
    it('should select the \'is fetching update\' flag', () => {
      const mockedState = { isFetchingUpdate: false };
      const selected = selectIsFetchingUpdate().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsCommittingUpdate', () => {
    it('should select the \'is committing update\' flag', () => {
      const mockedState = { isCommittingUpdate: false };
      const selected = selectIsCommittingUpdate().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectHasChangedUpdate', () => {
    it('should select the \'has changed update\' flag', () => {
      const mockedState = { hasChangedUpdate: true };
      const selected = selectHasChangedUpdate().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectPaginatedFields', () => {
    it('should select the paginated fields', () => {
      const mockedState = { fieldList: { id: 983, __dummy: '983' } };
      const selected = selectPaginatedFields().resultFunc(mockedState);

      expect(selected).toEqual({ id: 983, __dummy: '983' });
    });
  });

  describe('selectFieldsTotal', () => {
    it('should select the fields total', () => {
      const mockedState = { fieldListTotal: 718 };
      const selected = selectFieldsTotal().resultFunc(mockedState);

      expect(selected).toEqual(718);
    });
  });

  describe('selectField', () => {
    it('should select the field', () => {
      const mockedState = { currentField: { id: 948, __dummy: '948' } };
      const selected = selectField().resultFunc(mockedState);

      expect(selected).toEqual({ id: 948, __dummy: '948' });
    });
  });

  describe('selectIsFetchingFields', () => {
    it('should select the \'is fetching fields\' flag', () => {
      const mockedState = { isFetchingFields: false };
      const selected = selectIsFetchingFields().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsFetchingField', () => {
    it('should select the \'is fetching field\' flag', () => {
      const mockedState = { isFetchingField: false };
      const selected = selectIsFetchingField().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectIsCommittingField', () => {
    it('should select the \'is committing field\' flag', () => {
      const mockedState = { isCommittingField: false };
      const selected = selectIsCommittingField().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });

  describe('selectHasChangedField', () => {
    it('should select the \'has changed field\' flag', () => {
      const mockedState = { hasChangedField: false };
      const selected = selectHasChangedField().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
