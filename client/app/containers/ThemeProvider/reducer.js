/*
 *
 * ThemeProvider reducer
 *
 */

import { fromJS } from "immutable";

import { CHANGE_PRIMARY, CHANGE_SECONDARY } from "./constants";

export const initialState = fromJS({
    primary: "#3f51b5",
    secondary: "#f50057"
});

function themeProviderReducer(state = initialState, action) {
    switch (action.type) {
        case CHANGE_PRIMARY:
            return state.set("primary", action.color);
        case CHANGE_SECONDARY:
            return state.set("secondary", action.color);
        default:
            return state;
    }
}

export default themeProviderReducer;
