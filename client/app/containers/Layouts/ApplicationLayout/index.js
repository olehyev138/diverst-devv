import React, { memo } from 'react';
import { Route } from 'react-router';

import { withStyles } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';

const styles = theme => ({});

const ApplicationLayout = ({ component: Component, ...rest }) => {
  const { classes } = rest;

  return (
    <React.Fragment>
      <CssBaseline />
      <Component {...rest} />
    </React.Fragment>
  );
};

export default withStyles(styles)(ApplicationLayout);
