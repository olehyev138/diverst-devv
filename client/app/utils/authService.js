import { store } from 'configureStore';

const AuthService = {
  isAuthenticated() {
    const state = store.getState();

    if (state.global.token) return true;

    return false;
  },

  hasPermission(route) {
    return Object.prototype.hasOwnProperty.call(route, 'permission') === false || self.getPolicyGroup()[route.permission] === true;
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
