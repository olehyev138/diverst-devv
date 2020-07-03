import {
  GET_MENTORSHIP_USER_BEGIN,
  GET_MENTORSHIP_USER_ERROR,
  GET_MENTORSHIP_USER_SUCCESS,
  GET_MENTORSHIP_USERS_BEGIN,
  GET_MENTORSHIP_USERS_ERROR,
  GET_MENTORSHIP_USERS_SUCCESS,
  UPDATE_MENTORSHIP_USER_BEGIN,
  UPDATE_MENTORSHIP_USER_ERROR,
  UPDATE_MENTORSHIP_USER_SUCCESS
} from '../constants';

import {
  getUserBegin,
  getUserError,
  getUserSuccess,
  getUsersSuccess,
  getUsersBegin,
  getUsersError,
  updateUserBegin,
  updateUserError,
  updateUserSuccess
} from '../actions';

describe('mentorship actions', () => {
  describe('getUserBegin', () => {
    it('has a type of GET_MENTORSHIP_USER_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_MENTORSHIP_USER_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUsersuccess', () => {
    it('has a type of GET_MENTORSHIP_USER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_MENTORSHIP_USER_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserError', () => {
    it('has a type of GET_MENTORSHIP_USER_ERROR and sets a given error', () => {
      const expected = {
        type: GET_MENTORSHIP_USER_ERROR,
        error: { value: 709 }
      };

      expect(getUserError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getUsersBegin', () => {
    it('has a type of GET_MENTORSHIP_USERS_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_MENTORSHIP_USERS_BEGIN,
        payload: { value: 118 }
      };

      expect(getUsersBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUsersSuccess', () => {
    it('has a type of GET_MENTORSHIP_USERS_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_MENTORSHIP_USERS_SUCCESS,
        payload: { value: 118 }
      };

      expect(getUsersSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUsersError', () => {
    it('has a type of GET_MENTORSHIP_USERS_ERROR and sets a given error', () => {
      const expected = {
        type: GET_MENTORSHIP_USERS_ERROR,
        error: { value: 709 }
      };

      expect(getUsersError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateUserBegin', () => {
    it('has a type of UPDATE_MENTORSHIP_USER_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_MENTORSHIP_USER_BEGIN,
        payload: { value: 118 }
      };

      expect(updateUserBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUsersuccess', () => {
    it('has a type of UPDATE_MENTORSHIP_USER_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_MENTORSHIP_USER_SUCCESS,
        payload: { value: 865 }
      };

      expect(updateUserSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserError', () => {
    it('has a type of UPDATE_MENTORSHIP_USER_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_MENTORSHIP_USER_ERROR,
        error: { value: 709 }
      };

      expect(updateUserError({ value: 709 })).toEqual(expected);
    });
  });
});
