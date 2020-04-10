/**
 * app.js
 *
 * This is the entry file for the application, only setup and boilerplate
 * code.
 */

// Needed for redux-saga es6 generator support
import '@babel/polyfill';

// Import all the third party stuff
import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';
import 'sanitize.css/sanitize.css';

// Import Language Provider
import LanguageProvider from 'containers/Shared/LanguageProvider';
import InvalidSessionDetector from 'containers/Shared/InvalidSessionDetector';

// Load the favicon and the .htaccess file
/* eslint-disable import/no-unresolved, import/extensions */
import '!file-loader?name=[name].[ext]!./images/favicon.png';
import 'file-loader?name=.htaccess!./.htaccess';
/* eslint-enable import/no-unresolved, import/extensions */

import configureAxios from 'utils/axios';

// Import i18n messages
import { translationMessages } from './i18n';

import { store, history } from './configureStore';

import { LastLocationProvider } from 'react-router-last-location';
import ThemeProvider from 'containers/Shared/ThemeProvider/Loadable';

/* eslint-disable-next-line no-restricted-globals */
history.listen((location) => {
  const path = (/#!(\/.*)$/.exec(location.hash) || [])[1];
  if (path) {
    history.replace(path);
    document.location.href = path;
  }
});

configureAxios();

const MOUNT_NODE = document.getElementById('app');

const render = (messages) => {
  ReactDOM.render(
    <Provider store={store}>
      <LanguageProvider messages={messages}>
        <ConnectedRouter history={history}>
          <LastLocationProvider>
            <InvalidSessionDetector>
              <ThemeProvider />
            </InvalidSessionDetector>
          </LastLocationProvider>
        </ConnectedRouter>
      </LanguageProvider>
    </Provider>,
    MOUNT_NODE,
  );
};

if (module.hot)
  // Hot reloadable React components and translation json files
  // modules.hot.accept does not accept dynamic dependencies,
  // have to be constants at compile-time
  module.hot.accept(['./i18n', 'containers/Shared/App'], () => {
    ReactDOM.unmountComponentAtNode(MOUNT_NODE);
    render(translationMessages);
  });


// Chunked polyfill for browsers without Intl support
if (!window.Intl)
  new Promise((resolve) => {
    resolve(import('intl'));
  })
    .then(() => Promise.all([import('intl/locale-data/jsonp/en.js')]))
    .then(() => render(translationMessages))
    .catch((err) => {
      throw err;
    });
else
  render(translationMessages);


// Install ServiceWorker and AppCache in the end since
// it's not most important operation and if main code fails,
// we do not want it installed
if (process.env.NODE_ENV === 'production')
  require('offline-plugin/runtime').install(); // eslint-disable-line global-require
