import {
  selectMentorshipDomain, selectPaginatedUsers,
  selectUserTotal, selectUser,
  selectIsFetchingUsers,
  selectFormUser,
} from '../selectors';

import { initialState } from '../reducer';

describe('mentorship selectors', () => {
  describe('selectMentorshipDomain', () => {
    it('should select the mentorship domain', () => {
      const mockedState = { mentorship: { mentorship: {} } };
      const selected = selectMentorshipDomain(mockedState);

      expect(selected).toEqual({ mentorship: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectMentorshipDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectUserTotal', () => {
    it('should select the user total', () => {
      const mockedState = { userTotal: 289 };
      const selected = selectUserTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectUser', () => {
    it('should select the current user', () => {
      const mockedState = { currentUser: { id: 422, __dummy: '422' } };
      const selected = selectUser().resultFunc(mockedState);

      expect(selected).toEqual({ id: 422, __dummy: '422' });
    });
  });

  // TODO : Finish mentorship stuff first
  describe('selectPaginatedUsers', () => {
    xit('should select a list of users', () => {
      const mockedState = { userList: [{ id: 422, __dummy: '422' }] };
      const selected = selectUser().resultFunc(mockedState);

      expect(selected).toEqual([{ id: 422, __dummy: '422' }]);
    });
  });

  // TODO : Finish mentorship stuff first
  describe('selectIsFetchingUser', () => {
    xit('should select the isFetching property', () => {
      const mockedState = { isFetchingUsers: false };
      const selected = selectUser().resultFunc(mockedState);

      expect(selected).toEqual(false);
    });
  });
});
