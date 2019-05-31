/**
 *
 * App.js
 *
 * This component is the skeleton around the actual pages, and should only
 * contain code that should be seen on all pages. (e.g. navigation bar)
 *
 */

import React from 'react';

import { ToastContainer } from "react-toastify";

import Routes from "containers/Routes/Loadable";
import ErrorBoundary from "containers/ErrorBoundary";
import GlobalStyle from '../../global-styles';

import { useInjectSaga } from 'utils/injectSaga';
import saga from './saga';

export default function App() {
  useInjectSaga({ key: 'app', saga });

  return (
    <ErrorBoundary>
      <Routes/>
      <ToastContainer/>
      <GlobalStyle/>
    </ErrorBoundary>
  );
}
