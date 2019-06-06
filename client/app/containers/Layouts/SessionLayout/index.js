import React, { memo } from 'react';
import { Route } from 'react-router';
import { Redirect } from 'react-router-dom';
import AuthService from 'utils/authService';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import ApplicationLayout from '../ApplicationLayout';
import { withStyles } from '@material-ui/core/styles';

import { HOME_PATH } from 'containers/Routes/constants';

const styles = theme => ({
  container: {
    height: '100%',
  },
  content: {
    height: '100%',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
  },
});

const SessionLayout = ({ component: Component, ...rest }) => {
  const { classes, ...other } = rest;

  return (
    AuthService.isAuthenticated() === false
      ? (
        <ApplicationLayout
          {...other}
          component={matchProps => (
            <Container maxWidth='sm' className={classes.container}>
              <div className={classes.content}>
                <Component {...other} />
              </div>
            </Container>
          )}
        />
      )
      : <Redirect to={HOME_PATH} />
  );
};

SessionLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
};

export default withStyles(styles)(SessionLayout);
