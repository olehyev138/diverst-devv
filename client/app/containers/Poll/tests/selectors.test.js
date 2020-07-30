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

describe('Poll selectors', () => {
  describe('selectPollDomain', () => {
    it('should select the poll domain', () => {
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

  describe('selectPaginatedPolls', () => {
    it('should select the paginated polls', () => {
      const mockedState = { pollList: { id: 789, __dummy: '789' } };
      const selected = selectPaginatedPolls().resultFunc(mockedState);

      expect(selected).toEqual({ id: 789, __dummy: '789' });
    });
  });

  describe('selectPollsTotal', () => {
    it('should select the polls total', () => {
      const mockedState = { pollListTotal: 974 };
      const selected = selectPollsTotal().resultFunc(mockedState);

      expect(selected).toEqual(974);
    });
  });

  describe('selectPoll', () => {
    it('should select the currentPoll', () => {
      const mockedState = {
        currentPoll: {
          id: 374,
          fields: [{
            id: 123,
            title: 'Question',
            type: 'Type A'
          }],
          __dummy: '374'
        }
      };
      const selected = selectPoll().resultFunc(mockedState);

      expect(selected).toEqual({
        id: 374,
        __dummy: '374',
        fields: [{
          label: 'Question',
          value: 123,
          type: 'Type A'
        }]
      });
    });
  });

  describe('selectFormPoll', () => {
    it('should select the form poll', () => {
      const mockedState = {
        currentPoll: {
          id: 374,
          groups: [{
            id: 123,
            name: 'Group A',
          }],
          segments: [{
            id: 123,
            name: 'Segment A',
          }],
          __dummy: '374'
        }
      };
      const selected = selectFormPoll().resultFunc(mockedState);

      expect(selected).toEqual({
        id: 374,
        groups: [{
          value: 123,
          label: 'Group A',
        }],
        segments: [{
          value: 123,
          label: 'Segment A',
        }],
        __dummy: '374'
      });
    });
  });

  describe('selectIsFetchingPolls', () => {
    it('should select the \'is fetching polls\' flag', () => {
      const mockedState = { isFetchingPolls: true };
      const selected = selectIsFetchingPolls().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingPoll', () => {
    it('should select the \'is fetching poll\' flag', () => {
      const mockedState = { isFetchingPoll: false };
      const selected = selectIsFetchingPoll().resultFunc(mockedState);

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
