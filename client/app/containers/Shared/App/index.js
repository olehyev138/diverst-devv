/**
 *
 * App.js
 *
 * This component is the skeleton around the actual pages, and should only
 * contain code that should be seen on all pages. (e.g. navigation bar)
 *
 */

import React from 'react';

import Routes from 'containers/Shared/Routes/Loadable';
import ErrorBoundary from 'containers/Shared/ErrorBoundary';
import GlobalStyle from 'global-styles';
import Notifier from 'containers/Shared/Notifier/Loadable';

import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Shared/App/saga';

export default function App() {
  useInjectSaga({ key: 'app', saga });

  return (
    <ErrorBoundary>
      <Notifier />
      <Routes />
      <GlobalStyle />
    </ErrorBoundary>
  );
}
