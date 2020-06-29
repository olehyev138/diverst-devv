import {
  GET_USERS_BEGIN,
  GET_USERS_SUCCESS,
  GET_USERS_ERROR,
  GET_USER_BEGIN,
  GET_USER_SUCCESS,
  GET_USER_ERROR,
  GET_USER_POSTS_BEGIN,
  GET_USER_POSTS_SUCCESS,
  GET_USER_POSTS_ERROR,
  GET_USER_EVENTS_BEGIN,
  GET_USER_EVENTS_SUCCESS,
  GET_USER_EVENTS_ERROR,
  GET_USER_DOWNLOADS_BEGIN,
  GET_USER_DOWNLOADS_SUCCESS,
  GET_USER_DOWNLOADS_ERROR,
  CREATE_USER_BEGIN,
  CREATE_USER_SUCCESS,
  CREATE_USER_ERROR,
  UPDATE_USER_BEGIN,
  UPDATE_USER_SUCCESS,
  UPDATE_USER_ERROR,
  DELETE_USER_BEGIN,
  DELETE_USER_SUCCESS,
  DELETE_USER_ERROR,
  UPDATE_FIELD_DATA_BEGIN,
  UPDATE_FIELD_DATA_SUCCESS,
  UPDATE_FIELD_DATA_ERROR,
  EXPORT_USERS_BEGIN,
  EXPORT_USERS_SUCCESS,
  EXPORT_USERS_ERROR,
  GET_USER_DOWNLOAD_DATA_BEGIN,
  GET_USER_DOWNLOAD_DATA_SUCCESS,
  GET_USER_DOWNLOAD_DATA_ERROR,
  GET_USER_PROTOTYPE_BEGIN,
  GET_USER_PROTOTYPE_SUCCESS,
  GET_USER_PROTOTYPE_ERROR,
  USER_UNMOUNT,
} from '../constants';

import {
  getUserBegin, getUsersSuccess, getUsersError,
  getUsersBegin, getUserSuccess, getUserError,
  getUserPostsBegin, getUserPostsSuccess, getUserPostsError,
  getUserEventsBegin, getUserEventsSuccess, getUserEventsError,
  getUserDownloadsSuccess, getUserDownloadsError, getUserDownloadsBegin,
  createUserSuccess, createUserError, createUserBegin,
  updateUserSuccess, updateUserError, updateUserBegin,
  deleteUserSuccess, deleteUserError, deleteUserBegin,
  updateFieldDataSuccess, updateFieldDataError, updateFieldDataBegin,
  exportUsersSuccess, exportUsersError, exportUsersBegin,
  getUserDownloadDataSuccess, getUserDownloadDataError, getUserDownloadDataBegin,
  getUserPrototypeSuccess, getUserPrototypeError, getUserPrototypeBegin, userUnmount
} from '../actions';

describe('user actions', () => {
  describe('getUserPostsBegin', () => {
    it('has a type of GET_USER_POSTS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_POSTS_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserPostsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserPostsSuccess', () => {
    it('has a type of GET_USER_POSTS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_POSTS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserPostsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserPostsError', () => {
    it('has a type of GET_USER_POSTS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_POSTS_ERROR,
        error: { value: 709 }
      };

      expect(getUserPostsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('exportUsersBegin', () => {
    it('has a type of EXPORT_USERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: EXPORT_USERS_BEGIN,
        payload: { value: 118 }
      };

      expect(exportUsersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('exportUsersSuccess', () => {
    it('has a type of EXPORT_USERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: EXPORT_USERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(exportUsersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('exportUsersError', () => {
    it('has a type of EXPORT_USERS_ERROR and sets a given error', () => {
      const expected = {
        type: EXPORT_USERS_ERROR,
        error: { value: 709 }
      };

      expect(exportUsersError({ value: 709 })).toEqual(expected);
    });
  });


  describe('getUserPrototypeBegin', () => {
    it('has a type of GET_USER_PROTOTYPE_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_PROTOTYPE_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserPrototypeBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserPrototypeSuccess', () => {
    it('has a type of GET_USER_PROTOTYPE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_PROTOTYPE_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserPrototypeSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserPrototypeError', () => {
    it('has a type of GET_USER_PROTOTYPE_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_PROTOTYPE_ERROR,
        error: { value: 709 }
      };

      expect(getUserPrototypeError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getUserDownloadDataBegin', () => {
    it('has a type of GET_USER_DOWNLOAD_DATA_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_DOWNLOAD_DATA_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserDownloadDataBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserDownloadDataSuccess', () => {
    it('has a type of GET_USER_DOWNLOAD_DATA_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_DOWNLOAD_DATA_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserDownloadDataSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserDownloadDataError', () => {
    it('has a type of GET_USER_DOWNLOAD_DATA_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_DOWNLOAD_DATA_ERROR,
        error: { value: 709 }
      };

      expect(getUserDownloadDataError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateFieldDataBegin', () => {
    it('has a type of UPDATE_FIELD_DATA_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_FIELD_DATA_BEGIN,
        payload: { value: 118 }
      };

      expect(updateFieldDataBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateFieldDataSuccess', () => {
    it('has a type of UPDATE_FIELD_DATA_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_FIELD_DATA_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateFieldDataSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateFieldDataError', () => {
    it('has a type of UPDATE_FIELD_DATA_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_FIELD_DATA_ERROR,
        error: { value: 709 }
      };

      expect(updateFieldDataError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getUserDownloadsBegin', () => {
    it('has a type of GET_USER_DOWNLOADS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_DOWNLOADS_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserDownloadsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserDownloadsSuccess', () => {
    it('has a type of GET_USER_DOWNLOADS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_DOWNLOADS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserDownloadsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserDownloadsError', () => {
    it('has a type of GET_USER_DOWNLOADS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_DOWNLOADS_ERROR,
        error: { value: 709 }
      };

      expect(getUserDownloadsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getUserEventsBegin', () => {
    it('has a type of GET_USER_EVENTS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_EVENTS_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserEventsBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserEventsSuccess', () => {
    it('has a type of GET_USER_EVENTS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_EVENTS_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserEventsSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserEventsError', () => {
    it('has a type of GET_USER_EVENTS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_EVENTS_ERROR,
        error: { value: 709 }
      };

      expect(getUserEventsError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getUserBegin', () => {
    it('has a type of GET_USER_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserSuccess', () => {
    it('has a type of GET_USER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserError', () => {
    it('has a type of GET_USER_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_ERROR,
        error: { value: 709 }
      };

      expect(getUserError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getUsersBegin', () => {
    it('has a type of GET_USERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USERS_BEGIN,
        payload: { value: 118 }
      };

      expect(getUsersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUsersSuccess', () => {
    it('has a type of GET_USERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getUsersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUsersError', () => {
    it('has a type of GET_USERS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USERS_ERROR,
        error: { value: 709 }
      };

      expect(getUsersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createUserBegin', () => {
    it('has a type of CREATE_USER_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_USER_BEGIN,
        payload: { value: 118 }
      };

      expect(createUserBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createUserSuccess', () => {
    it('has a type of CREATE_USER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_USER_SUCCESS,
        payload: { value: 118 }
      };

      expect(createUserSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createUserError', () => {
    it('has a type of CREATE_USER_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_USER_ERROR,
        error: { value: 709 }
      };

      expect(createUserError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateUserBegin', () => {
    it('has a type of UPDATE_USER_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_USER_BEGIN,
        payload: { value: 118 }
      };

      expect(updateUserBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateUserSuccess', () => {
    it('has a type of UPDATE_USER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_USER_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateUserSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateUserError', () => {
    it('has a type of UPDATE_USER_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_USER_ERROR,
        error: { value: 709 }
      };

      expect(updateUserError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteUserBegin', () => {
    it('has a type of DELETE_USER_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_USER_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteUserBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteUserSuccess', () => {
    it('has a type of DELETE_USER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_USER_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteUserSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteUserError', () => {
    it('has a type of DELETE_USER_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_USER_ERROR,
        error: { value: 709 }
      };

      expect(deleteUserError({ value: 709 })).toEqual(expected);
    });
  });

  describe('userUnmount', () => {
    it('has a type of USER_UNMOUNT', () => {
      const expected = {
        type: USER_UNMOUNT,
      };

      expect(userUnmount()).toEqual(expected);
    });
  });
});
