import {
  GET_USER_ROLE_BEGIN,
  GET_USER_ROLE_SUCCESS,
  GET_USER_ROLE_ERROR,
  GET_USER_ROLES_BEGIN,
  GET_USER_ROLES_SUCCESS,
  GET_USER_ROLES_ERROR,
  CREATE_USER_ROLE_BEGIN,
  CREATE_USER_ROLE_SUCCESS,
  CREATE_USER_ROLE_ERROR,
  UPDATE_USER_ROLE_BEGIN,
  UPDATE_USER_ROLE_SUCCESS,
  UPDATE_USER_ROLE_ERROR,
  DELETE_USER_ROLE_BEGIN,
  DELETE_USER_ROLE_SUCCESS,
  DELETE_USER_ROLE_ERROR,
  USER_ROLE_UNMOUNT,
} from '../constants';

import {
  getUserRoleBegin,
  getUserRoleError,
  getUserRoleSuccess,
  getUserRolesBegin,
  getUserRolesError,
  getUserRolesSuccess,
  createUserRoleBegin,
  createUserRoleError,
  createUserRoleSuccess,
  updateUserRoleBegin,
  updateUserRoleError,
  updateUserRoleSuccess,
  deleteUserRoleBegin,
  deleteUserRoleError,
  deleteUserRoleSuccess,
  userRoleUnmount
} from '../actions';

describe('userRole actions', () => {
  describe('getUserRoleBegin', () => {
    it('has a type of GET_USER_ROLE_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_ROLE_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserRoleBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserRoleSuccess', () => {
    it('has a type of GET_USER_ROLE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_ROLE_SUCCESS,
        payload: { value: 865 }
      };

      expect(getUserRoleSuccess({ value: 865 })).toEqual(expected);
    });
  });

  describe('getUserRoleError', () => {
    it('has a type of GET_USER_ROLE_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_ROLE_ERROR,
        error: { value: 709 }
      };

      expect(getUserRoleError({ value: 709 })).toEqual(expected);
    });
  });

  describe('getUserRolesBegin', () => {
    it('has a type of GET_USER_ROLES_BEGIN and sets a given payload', () => {
      const expected = {
        type: GET_USER_ROLES_BEGIN,
        payload: { value: 118 }
      };

      expect(getUserRolesBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserRolesSuccess', () => {
    it('has a type of GET_USER_ROLES_SUCCESS and sets a given payload', () => {
      const expected = {
        type: GET_USER_ROLES_SUCCESS,
        payload: { value: 118 }
      };

      expect(getUserRolesSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('getUserRolesError', () => {
    it('has a type of GET_USER_ROLES_ERROR and sets a given error', () => {
      const expected = {
        type: GET_USER_ROLES_ERROR,
        error: { value: 709 }
      };

      expect(getUserRolesError({ value: 709 })).toEqual(expected);
    });
  });

  describe('createUserRoleBegin', () => {
    it('has a type of CREATE_USER_ROLE_BEGIN and sets a given payload', () => {
      const expected = {
        type: CREATE_USER_ROLE_BEGIN,
        payload: { value: 118 }
      };

      expect(createUserRoleBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('createUserRoleSuccess', () => {
    it('has a type of CREATE_USER_ROLE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: CREATE_USER_ROLE_SUCCESS,
        payload: { value: 118 }
      };

      expect(createUserRoleSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('createUserRoleError', () => {
    it('has a type of CREATE_USER_ROLE_ERROR and sets a given error', () => {
      const expected = {
        type: CREATE_USER_ROLE_ERROR,
        error: { value: 709 }
      };

      expect(createUserRoleError({ value: 709 })).toEqual(expected);
    });
  });

  describe('updateUserRoleBegin', () => {
    it('has a type of UPDATE_USER_ROLE_BEGIN and sets a given payload', () => {
      const expected = {
        type: UPDATE_USER_ROLE_BEGIN,
        payload: { value: 118 }
      };

      expect(updateUserRoleBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateUserRoleSuccess', () => {
    it('has a type of UPDATE_USER_ROLE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: UPDATE_USER_ROLE_SUCCESS,
        payload: { value: 118 }
      };

      expect(updateUserRoleSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('updateUserRoleError', () => {
    it('has a type of UPDATE_USER_ROLE_ERROR and sets a given error', () => {
      const expected = {
        type: UPDATE_USER_ROLE_ERROR,
        error: { value: 709 }
      };

      expect(updateUserRoleError({ value: 709 })).toEqual(expected);
    });
  });

  describe('deleteUserRoleBegin', () => {
    it('has a type of DELETE_USER_ROLE_BEGIN and sets a given payload', () => {
      const expected = {
        type: DELETE_USER_ROLE_BEGIN,
        payload: { value: 118 }
      };

      expect(deleteUserRoleBegin({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteUserRoleSuccess', () => {
    it('has a type of DELETE_USER_ROLE_SUCCESS and sets a given payload', () => {
      const expected = {
        type: DELETE_USER_ROLE_SUCCESS,
        payload: { value: 118 }
      };

      expect(deleteUserRoleSuccess({ value: 118 })).toEqual(expected);
    });
  });

  describe('deleteUserRoleError', () => {
    it('has a type of DELETE_USER_ROLE_ERROR and sets a given error', () => {
      const expected = {
        type: DELETE_USER_ROLE_ERROR,
        error: { value: 709 }
      };

      expect(deleteUserRoleError({ value: 709 })).toEqual(expected);
    });
  });

  describe('userRoleUnmount', () => {
    it('has a type of USER_ROLE_UNMOUNT', () => {
      const expected = {
        type: USER_ROLE_UNMOUNT,
      };

      expect(userRoleUnmount()).toEqual(expected);
    });
  });
});
