import React, { memo, useEffect } from 'react';
import { Route } from 'react-router';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';

const styles = theme => ({});

export const RouteContext = React.createContext(null);

const ApplicationLayout = ({ component: Component, ...rest }) => {
  const { classes, ...other } = rest;

  return (
    <Route
      {...other}
      render={routeProps => (
        <RouteContext.Provider
          value={{
            computedMatch: routeProps.match,
            location: routeProps.location
          }}
        >
          <CssBaseline />
          <Component {...rest} />
        </RouteContext.Provider>
      )}
    />
  );
};

ApplicationLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
};

export default withStyles(styles)(ApplicationLayout);
