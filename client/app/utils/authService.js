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


  // Get the global data object from the store or from the user storage
  static getUserData() {
    const state = store.getState();

    return dig(state, 'global', 'data') || UserStorage.getStorageValue('userData');
  }

  // Store a global data object in user storage
  static storeUserData(data) {
    UserStorage.setStorageValue('userData', data);
  }

  // Remove the global data object from user storage
  static discardUserData() {
    UserStorage.clearStorageValue('userData');
  }


  // Get Policy Group from the global data
  static getPolicyGroup() {
    return dig(this.getUserData(), 'policy_group');
  }

  // Get Enterprise from the global data
  static getEnterprise() {
    return dig(this.getUserData(), 'enterprise');
  }


  // *************** Helpers ***************

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
