/*
 *
 * User reducer
 *
 */

import produce from 'immer/dist/immer';
import {
  GET_USERS_BEGIN, GET_USERS_SUCCESS,
  GET_USERS_ERROR, GET_USER_SUCCESS, USER_UNMOUNT,
  GET_USER_POSTS_SUCCESS, GET_USER_EVENTS_BEGIN,
  GET_USER_EVENTS_SUCCESS, GET_USER_POSTS_BEGIN,
  CREATE_USER_BEGIN, CREATE_USER_SUCCESS, CREATE_USER_ERROR,
  UPDATE_USER_BEGIN, UPDATE_USER_SUCCESS, UPDATE_USER_ERROR,
  UPDATE_FIELD_DATA_BEGIN, UPDATE_FIELD_DATA_SUCCESS, UPDATE_FIELD_DATA_ERROR,
  GET_USER_BEGIN, GET_USER_ERROR, GET_USER_DOWNLOADS_BEGIN, GET_USER_DOWNLOADS_SUCCESS,
  GET_USER_DOWNLOADS_ERROR, GET_USER_DOWNLOAD_DATA_BEGIN, GET_USER_DOWNLOAD_DATA_SUCCESS, GET_USER_DOWNLOAD_DATA_ERROR,
} from 'containers/User/constants';

export const initialState = {
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

/* eslint-disable-next-line default-case, no-param-reassign */
function usersReducer(state = initialState, action) {
  /* eslint-disable consistent-return */
  return produce(state, (draft) => {
    switch (action.type) {
      case GET_USERS_BEGIN:
        draft.isFetchingUsers = true;
        return;
      case GET_USERS_SUCCESS:
        draft.userList = formatUsers(action.payload.items);
        draft.userTotal = action.payload.total;
        draft.isFetchingUsers = false;
        break;
      case GET_USERS_ERROR:
        draft.isFetchingUsers = false;
        return;
      case GET_USER_BEGIN:
        draft.isFormLoading = true;
        break;
      case GET_USER_SUCCESS:
        draft.currentUser = action.payload.user;
        draft.isFormLoading = false;
        break;
      case GET_USER_ERROR:
        draft.isFormLoading = false;
        break;
      case GET_USER_POSTS_BEGIN:
        draft.isLoadingPosts = true;
        break;
      case GET_USER_POSTS_SUCCESS:
        draft.posts = action.payload.items;
        draft.postsTotal = action.payload.total;
        draft.isLoadingPosts = false;
        break;
      case GET_USER_EVENTS_BEGIN:
        draft.isLoadingEvents = true;
        break;
      case GET_USER_EVENTS_SUCCESS:
        draft.events = action.payload.items;
        draft.eventsTotal = action.payload.total;
        draft.isLoadingEvents = false;
        break;
      case GET_USER_DOWNLOADS_BEGIN:
        draft.isLoadingDownloads = true;
        break;
      case GET_USER_DOWNLOADS_SUCCESS:
        draft.downloads = action.payload.items;
        draft.downloadsTotal = action.payload.total;
        draft.isLoadingDownloads = false;
        break;
      case CREATE_USER_BEGIN:
      case UPDATE_USER_BEGIN:
      case UPDATE_FIELD_DATA_BEGIN:
        draft.isCommitting = true;
        break;
      case CREATE_USER_SUCCESS:
      case UPDATE_USER_SUCCESS:
      case UPDATE_FIELD_DATA_SUCCESS:
      case CREATE_USER_ERROR:
      case UPDATE_USER_ERROR:
      case UPDATE_FIELD_DATA_ERROR:
        draft.isCommitting = false;
        break;
      case GET_USER_DOWNLOAD_DATA_BEGIN:
        draft.isDownloadingData = true;
        draft.downloadData.data = null;
        draft.downloadData.contentType = null;
        break;
      case GET_USER_DOWNLOAD_DATA_SUCCESS:
        draft.isDownloadingData = false;
        draft.downloadData.data = action.payload.data;
        draft.downloadData.contentType = action.payload.contentType;
        break;
      case GET_USER_DOWNLOAD_DATA_ERROR:
        draft.isDownloadingData = false;
        break;
      case USER_UNMOUNT:
        return initialState;
    }
  });
}

/* Helpers */

/*
 * Format users to hash by id
 */
function formatUsers(users) {
  return users.reduce((map, user) => {
    map[user.id] = user;
    return map;
  }, {});
}


export default usersReducer;
