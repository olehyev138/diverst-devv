import React, { memo } from 'react';
import { Route } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import CssBaseline from '@material-ui/core/CssBaseline';
import Fade from '@material-ui/core/Fade';

export const RouteContext = React.createContext(null);

const ApplicationLayout = ({ component: Component, ...rest }) => {
  const { classes, ...other } = rest;

  return (
    <Route
      {...other}
      render={routeProps => (
        <RouteContext.Provider
          value={{
            history: routeProps.history,
            location: routeProps.location,
            computedMatch: routeProps.match,
          }}
        >
          <CssBaseline />
          <Fade in appear>
            <Component {...rest} {...routeProps} />
          </Fade>
        </RouteContext.Provider>
      )}
    />
  );
};

ApplicationLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
};

export default compose(
  memo,
)(ApplicationLayout);
