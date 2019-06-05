import { store } from 'configureStore';

function getValue(key) {
  let value = window.sessionStorage.getItem(key);
  if (typeof value !== 'undefined' && value !== 'undefined') {
    return JSON.parse(value);
  }
  value = window.localStorage.getItem(key);

  if (typeof value !== 'undefined' && value !== 'undefined') {
    return JSON.parse(value);
  }

  return undefined;
}

const AuthService = {
  isAuthenticated() {
    const state = store.getState();
    if (state.global.token) return true;

    return false;
  },
  setValue(key, value) {
    window.localStorage.setItem(key, JSON.stringify(value));
    window.sessionStorage.setItem(key, JSON.stringify(value));
  },
  getJwt() {
    const state = store.getState();
    const jwt = state.global.token || getValue('_diverst.twj');
    return jwt;
  },
  getEnterprise() {
    const state = store.getState();
    return state.global.enterprise || getValue('_diverst.seirpretne');
  },
  clear() {
    window.sessionStorage.clear();
    window.localStorage.clear();
  }
};

export default AuthService;
