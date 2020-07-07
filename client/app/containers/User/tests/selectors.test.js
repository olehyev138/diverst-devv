import {
  selectUsersDomain, selectPaginatedUsers,
  selectPaginatedSelectUsers,
  selectUserTotal, selectUser, selectFieldData,
  selectIsFetchingUsers, selectIsLoadingPosts,
  selectIsLoadingEvents, selectFormUser, selectCalendarEvents,
  selectPaginatedPosts, selectPostsTotal,
  selectPaginatedEvents, selectEventsTotal,
  selectIsCommitting, selectIsFormLoading,
  selectPaginatedDownloads, selectDownloadsTotal,
  selectIsLoadingDownloads, selectIsDownloadingData,
  selectDownloadData,
} from '../selectors';

import { initialState } from '../reducer';

describe('User selectors', () => {
  describe('selectUserDomain', () => {
    it('should select the user domain', () => {
      const mockedState = { users: { user: {} } };
      const selected = selectUsersDomain(mockedState);

      expect(selected).toEqual({ user: {} });
    });

    it('should select initialState', () => {
      const mockedState = { };
      const selected = selectUsersDomain(mockedState);

      expect(selected).toEqual(initialState);
    });
  });

  describe('selectIsCommitting', () => {
    it('should select the \'is committing\' flag', () => {
      const mockedState = { isCommitting: true };
      const selected = selectIsCommitting().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFormLoading', () => {
    it('should select the \'is FormLoading\' flag', () => {
      const mockedState = { isFormLoading: true };
      const selected = selectIsFormLoading().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsDownloadingData', () => {
    it('should select the \'is DownloadingData\' flag', () => {
      const mockedState = { isDownloadingData: true };
      const selected = selectIsDownloadingData().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsLoadingDownloads', () => {
    it('should select the \'is LoadingDownloads\' flag', () => {
      const mockedState = { isLoadingDownloads: true };
      const selected = selectIsLoadingDownloads().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsLoadingEvents', () => {
    it('should select the \'is LoadingEvents\' flag', () => {
      const mockedState = { isLoadingEvents: true };
      const selected = selectIsLoadingEvents().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsFetchingUsers', () => {
    it('should select the \'is IsFetchingUsers\' flag', () => {
      const mockedState = { isFetchingUsers: true };
      const selected = selectIsFetchingUsers().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectIsLoadingPosts', () => {
    it('should select the \'is LoadingPosts\' flag', () => {
      const mockedState = { isLoadingPosts: true };
      const selected = selectIsLoadingPosts().resultFunc(mockedState);

      expect(selected).toEqual(true);
    });
  });

  describe('selectDownloadsTotal', () => {
    it('should select the Downloads total', () => {
      const mockedState = { downloadsTotal: 289 };
      const selected = selectDownloadsTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectPostsTotal', () => {
    it('should select the Posts total', () => {
      const mockedState = { postsTotal: 289 };
      const selected = selectPostsTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectEventsTotal', () => {
    it('should select the Events total', () => {
      const mockedState = { eventsTotal: 289 };
      const selected = selectEventsTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectUserTotal', () => {
    it('should select the User total', () => {
      const mockedState = { userTotal: 289 };
      const selected = selectUserTotal().resultFunc(mockedState);

      expect(selected).toEqual(289);
    });
  });

  describe('selectUser', () => {
    it('should select the User', () => {
      const mockedState = { currentUser: {} };
      const selected = selectUser().resultFunc(mockedState);

      expect(selected).toEqual({});
    });
  });

  describe('selectPaginatedUsers', () => {
    it('should select the userList', () => {
      const mockedState = { userList: [] };
      const selected = selectPaginatedUsers().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectPaginatedSelectUsers', () => {
    it('should select the userList', () => {
      const mockedState = { userList: [] };
      const selected = selectPaginatedSelectUsers().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectFieldData', () => {
    it('should select the userList', () => {
      const mockedState = { currentUser: { field_data: [{ data: 'abc', field: { } }] } };
      const selected = selectFieldData().resultFunc(mockedState);

      expect(selected).toEqual([{ data: 'abc', field: { options: null } }]);
    });

    it('should return undefined', () => {
      const mockedState = { field_data: {}, currentUser: {} };
      const selected = selectFieldData().resultFunc(mockedState);

      expect(selected).toEqual(undefined);
    });
  });

  describe('selectFormUser', () => {
    it('should have undefined', () => {
      const mockedState = { currentUser: { user: { timezones: [] } } };
      const selected = selectFieldData().resultFunc(mockedState);

      expect(selected).toEqual(undefined);
    });

    it('should return null', () => {
      const mockedState = { undefined };
      const selected = selectFormUser().resultFunc(mockedState);

      expect(selected).toEqual(null);
    });
  });

  describe('selectCalendarEvents', () => {
    it('should select events', () => {
      const mockedState = { events: [] };
      const selected = selectCalendarEvents().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectPaginatedPosts', () => {
    it('should select posts', () => {
      const mockedState = { posts: [] };
      const selected = selectPaginatedPosts().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectPaginatedEvents', () => {
    it('should select events', () => {
      const mockedState = { events: [] };
      const selected = selectPaginatedEvents().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectPaginatedDownloads', () => {
    it('should select downloads', () => {
      const mockedState = { downloads: [] };
      const selected = selectPaginatedDownloads().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });

  describe('selectDownloadData', () => {
    it('should select downloadData', () => {
      const mockedState = { downloadData: [] };
      const selected = selectDownloadData().resultFunc(mockedState);

      expect(selected).toEqual([]);
    });
  });
});
