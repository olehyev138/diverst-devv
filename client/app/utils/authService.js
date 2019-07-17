import { store } from 'configureStore';

const AuthService = {
  isAuthenticated() {
    const state = store.getState();

    if (state.global.token) return true;

    return false;
  },

  hasPermission(routeData) {
    if (!routeData)
      return true;

    return Object.prototype.hasOwnProperty.call(routeData, 'permission') === false || AuthService.getPolicyGroup()[routeData.permission] === true;
  },

  getPolicyGroup() {
    const state = store.getState();

    return state.global.policy_group || undefined;
  },

  getEnterprise() {
    const state = store.getState();
    return state.global.enterprise || undefined;
  },
};

export default AuthService;
