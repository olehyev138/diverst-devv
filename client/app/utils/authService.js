import { store } from 'configureStore';
import dig from 'object-dig';

import UserStorage from './userStorage';

class AuthService {
  constructor() { throw Error('Do not make instances of AuthService - Use the static methods instead'); }

  // Get JWT from the store or from the user storage
  static getJwt() {
    const state = store.getState();

    return dig(state, 'global', 'token') || UserStorage.getStorageValue('jwt');
  }

  // Store JWT in user storage
  static storeJwt(jwt) {
    UserStorage.setStorageValue('jwt', jwt);
  }

  // Remove JWT from user storage
  static discardJwt() {
    UserStorage.clearStorageValue('jwt');
  }

  // *********** Store Accessors ***********

  // Get Policy Group from the store
  static getPolicyGroup() {
    const state = store.getState();

    return dig(state, 'global', 'policyGroup');
  }

  // Get Enterprise from the store
  static getEnterprise() {
    const state = store.getState();

    return dig(state, 'global', 'enterprise');
  }

  // *************** Helpers ***************

  // Returns the parsed user data from the JWT provided (or defaults to retrieving it)
  static getUser(jwt = AuthService.getJwt()) {
    return JSON.parse(window.atob(jwt.split('.')[1]));
  }

  // Returns true if the user is authenticated and the data is in the store
  static isUserInStore() {
    const state = store.getState();

    return !!dig(state, 'global', 'token');
  }

  // Returns true if the passed in routeData object contains a `permission` property that contains
  // a string which represents the field name of the permission in the user's policy group
  //
  // Note: routeData should be passed directly from the route object from 'Routes/constants.js'
  static hasPermission(routeData) {
    // If routeData is empty or doesn't contain a permission property then there's no
    // permission for the provided page so the user is authorized
    if (!routeData || Object.prototype.hasOwnProperty.call(routeData, 'permission') === false)
      return true;

    return AuthService.getPolicyGroup()[routeData.permission] === true;
  }
}

export default AuthService;
