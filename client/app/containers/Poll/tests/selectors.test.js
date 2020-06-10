import {
  selectPollDomain,
  selectPaginatedPolls,
  selectPollsTotal,
  selectPoll,
  selectFormPoll,
  selectIsFetchingPolls,
  selectIsFetchingPoll,
  selectIsCommitting,
  selectHasChanged,
} from '../selectors';

import { initialState } from '../reducer';
import {selectIsLoggingIn} from "../../Session/LoginPage/selectors";

describe('Poll selectors', () => {
  describe('selectPollDomain', () => {
    it('should select the archives domain', () => {
      const mockedState = { polls: { poll: {} } };
      const selected = selectPollDomain(mockedState);

      expect(selected).toEqual({ poll: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectPollDomain(mockedState);

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

  describe('selectPollsTotal', () => {
    it('should select the archive total', () => {
      const mockedState = { pollListTotal: 289 };
      const selected = selectPollsTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectIsFetchingPoll', () => {
    it('should select the \'is fetchingPoll\' flag', () => {
      const mockedState = { isFetchingPoll: true };
      const selected = selectIsFetchingPoll().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingPolls', () => {
    it('should select the \'is fetchingPolls\' flag', () => {
      const mockedState = { isFetchingPolls: true };
      const selected = selectIsFetchingPolls().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectPoll', () => {
    it('should select the currentPoll', () => {
      const mockedState = { currentPoll: { id: 374, __dummy: '374' } };
      const selected = selectPoll().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });

  describe('selectPaginatedPolls', () => {
    it('should select the paginated polls', () => {
      const mockedState = { pollList: [{ id: 37, name: 'dummy' }] };
      const selected = selectPaginatedPolls().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 37, name: 'dummy' }]);
    });
  });

  describe('selectFormPoll', () => {
    it('should select currentPoll and do more stuff', () => {
      const mockedState = { currentPoll: { id: 374, __dummy: '374' } };
      const selected = selectPoll().resultFunc(mockedState);

      expect(selected).toEqual({ id: 374, __dummy: '374' });
    });
  });
});
