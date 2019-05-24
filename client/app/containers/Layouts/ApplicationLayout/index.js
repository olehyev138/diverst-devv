import React, { memo } from 'react';
import { Route } from 'react-router';
import AuthService from "utils/authService";

import ApplicationHeader from 'components/ApplicationHeader';
import { withStyles } from "@material-ui/core/styles";

const styles = theme => ({
  toolbar: theme.mixins.toolbar,
});

const ApplicationLayout = ({position: position, isAdmin: isAdmin, component: Component, classes: classes, ...rest}) => {
  return (
    AuthService.isAuthenticated() === true ?
      <Route {...rest} render={matchProps => (
        <div>
          <ApplicationHeader position={position} isAdmin={isAdmin} {...matchProps}/>
          <Component {...matchProps} />
        </div>
      )} />
      : <div/>
  )
};

export default withStyles(styles)(ApplicationLayout);
