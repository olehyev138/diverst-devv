/**
 * Combine all reducers in this file and export the combined reducers.
 */

import { combineReducers } from 'redux';
import { connectRouter } from 'connected-react-router';

import history from 'utils/history';
import globalReducer from 'containers/Shared/App/reducer';
// import themeReducer from "containers/ThemeProvider/reducer";
import languageProviderReducer from 'containers/Shared/LanguageProvider/reducer';

/**
 * Merges the main reducer with the router state and dynamically injected reducers
 */
export default function createReducer(injectedReducers = {}) {
  return combineReducers({
    global: globalReducer,
    // theme: themeReducer,
    language: languageProviderReducer,
    router: connectRouter(history),
    ...injectedReducers,
  });
}
