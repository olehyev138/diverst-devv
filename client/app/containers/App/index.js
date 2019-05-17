/**
 *
 * App
 *
 * This component is the skeleton around the actual pages, and should only
 * contain code that should be seen on all pages. (e.g. navigation bar)
 */

import React from "react";
import { ToastContainer } from "react-toastify";
// Import Theme Provider
import Routes from "containers/Routes/Loadable";
import ErrorBoundary from "containers/ErrorBoundary";
import GlobalStyle from "../../global-styles";

export default function App() {
    return (
        <div>
            <ErrorBoundary>
                <Routes/>
                <ToastContainer />
                <GlobalStyle />
            </ErrorBoundary>
        </div>
    );
}