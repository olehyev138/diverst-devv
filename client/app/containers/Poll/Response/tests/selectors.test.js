import {
  selectResponseDomain,
  selectPaginatedResponses,
  selectResponsesTotal,
  selectResponse,
  selectIsFetchingResponses,
  selectIsFetchingResponse,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

import { initialState } from '../reducer';

describe('Response selectors', () => {
  describe('selectResponseDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { responses: { response: {} } };
      const selected = selectResponseDomain(mockedState);

      expect(selected).toEqual({ response: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectResponseDomain(mockedState);

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

  describe('selectResponsesTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { responseListTotal: 289 };
      const selected = selectResponsesTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingResponse', () => {
    it('should select the \'is fetchingResponse\' flag', () => {
      const mockedState = { isFetchingResponse: true };
      const selected = selectIsFetchingResponse().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingResponses', () => {
    it('should select the \'is fetchingResponses\' flag', () => {
      const mockedState = { isFetchingResponses: true };
      const selected = selectIsFetchingResponses().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectResponse', () => {
    it('should select the currentResponse', () => {
      const mockedState = { currentResponse: { id: 374, __dummy: '374' } };
      const selected = selectResponse().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedResponses', () => {
    it('should select the paginated responses', () => {
      const mockedState = { responseList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedResponses().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy', field_data: undefined, respondent: 'Anonymous' }]);
    });
  });

  describe('selectFormResponse', () => {
    it('should select currentResponse and do more stuff', () => {
      const mockedState = { currentResponse: { id: 374, __dummy: '374' } };
      const selected = selectResponse().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });
});
