/*
 * AppConstants
 * Each action has a corresponding type, which the reducer knows and picks up on.
 * To avoid weird typos between the reducer and the actions, we save them as
 * constants here. We prefix them with 'yourproject/YourComponent' so we avoid
 * reducers accidentally picking up actions they shouldn't.
 *
 * Follow this format:
 * export const YOUR_ACTION_CONSTANT = 'yourproject/YourContainer/YOUR_ACTION_CONSTANT';
 */

export const LOGGED_IN = "LOGGED_IN";
export const LOG_OUT = "LOG_OUT";
export const LOG_OUT_ERROR = "LOG_OUT_ERROR";
export const SET_CURRENT_USER = "SET_CURRENT_USER";
export const SET_ENTERPRISE = "SET_ENTERPRISE";