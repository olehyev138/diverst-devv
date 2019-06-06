import React, { memo } from 'react';
import { Route } from 'react-router';

import { withStyles } from "@material-ui/core/styles";
import CssBaseline from "@material-ui/core/CssBaseline";

const styles = theme => ({});

const ApplicationLayout = ({ component: Component, ...rest}) => {
  const { classes, ...other } = rest;

  return (
    <Route {...other}>
      <CssBaseline />
      <Component {...rest} />
    </Route>
  )
};

export default withStyles(styles)(ApplicationLayout);
