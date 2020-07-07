import produce from 'immer';
import {
  getUserSuccess,
  getUsersSuccess
} from '../actions';
import userReducer from 'containers/User/reducer';

/* eslint-disable default-case, no-param-reassign */
describe('userReducer', () => {
  let state;
  beforeEach(() => {
    state = {
      isLoadingPosts: true,
      isLoadingEvents: true,
      isLoadingDownloads: true,
      isFormLoading: true,
      isCommitting: false,
      userList: {},
      userTotal: null,
      currentUser: null,
      isFetchingUsers: true,
      posts: [],
      postsTotal: null,
      events: [],
      eventsTotal: null,
      downloads: [],
      downloadsTotal: null,
      isDownloadingData: false,
      downloadData: {
        data: null,
        contentType: null,
      },
    };
  });

  it('returns the initial state', () => {
    const expected = state;
    expect(userReducer(undefined, {})).toEqual(expected);
  });

  it('handles the getUsersSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.userList = { 4: { id: 4, name: 'dummy' } };
      draft.userTotal = 31;
      draft.isFetchingUsers = false;
    });

    expect(
      userReducer(
        state,
        getUsersSuccess({
          items: [{ id: 4, name: 'dummy' }],
          total: 31,
        })
      )
    ).toEqual(expected);
  });

  it('handles the getUserSuccess action correctly', () => {
    const expected = produce(state, (draft) => {
      draft.currentUser = { id: 4, name: 'dummy' };
      draft.isFormLoading = false;
    });

    expect(
      userReducer(
        state,
        getUserSuccess({
          user: { id: 4, name: 'dummy' },
        })
      )
    ).toEqual(expected);
  });
});
