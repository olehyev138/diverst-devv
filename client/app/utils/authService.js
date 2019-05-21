import { store } from 'configureStore'

function getValue(key) {
    var value = window.sessionStorage.getItem(key);
    if (typeof value !== "undefined" && value !== "undefined") {
        return JSON.parse(value);
    }
    value = window.localStorage.getItem(key);

    if (typeof value !== "undefined" && value !== "undefined") {
        return JSON.parse(value);
    }
    else {
        return undefined;
    }
}

const AuthService = {
    isAuthenticated() {
        const state = store.getState();
        if (state.get("global").get("token")) {
            return true;
        }
        return false;
    },
    setValue(key, value) {
        window.localStorage.setItem(key, JSON.stringify(value));
        window.sessionStorage.setItem(key, JSON.stringify(value));
    },
    getJwt() {
        const state = store.getState();
        let jwt = state.get("global").get("token") || getValue("_diverst.twj");
        return jwt;
    },
    getEnterprise() {
        const state = store.getState();
        return state.get("global").get("enterprise") || getValue("_diverst.seirpretne");
    },
    clear() {
        window.sessionStorage.clear();
        window.localStorage.clear();
    }
};

export default AuthService;
