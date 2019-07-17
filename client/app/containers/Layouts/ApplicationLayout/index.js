import React, { memo } from 'react';
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
    >
      <RouteContext.Provider
        value={{
          computedMatch: other.computedMatch,
          location: other.location
        }}
      >
        <CssBaseline />
        <Component {...rest} />
      </RouteContext.Provider>
    </Route>
  );
};

ApplicationLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
};

export default withStyles(styles)(ApplicationLayout);
