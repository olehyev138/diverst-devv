import {
  selectPollResponseDomain, selectToken,
  selectIsLoading, selectResponse, selectFormErrors,
  selectIsCommitting,
} from '../selectors';

import { initialState } from '../reducer';

describe('Poll selectors', () => {
  describe('selectPollDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { pollResponse: { } };
      const selected = selectPollResponseDomain(mockedState);

      expect(selected).toEqual({ });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectPollResponseDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectToken', () => {
    it('should select the token', () => {
      const mockedState = { token: {} };
      const selected = selectToken().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectFormErrors', () => {
    it('should select the errors', () => {
      const mockedState = { errors: {} };
      const selected = selectFormErrors().resultFunc(mockedState);

      expect(selected).toEqual({});
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
    it('should select the \'is isLoading\' flag', () => {
      const mockedState = { isLoading: true };
      const selected = selectIsLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  // TODO
  describe('selectResponse', () => {
    xit('should select the currentUser', () => {
      const mockedState = { response: [{ id: 374, __dummy: '374' }] };
      const selected = selectResponse().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 374, __dummy: '374' }]);
    });

    it('should return null', () => {
      const mockedState = { abc: 123 };
      const selected = selectResponse().resultFunc(mockedState);

      expect(selected).toEqual(null);
    });
  });
});
