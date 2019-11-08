import React, { memo } from 'react';
import { compose } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';
import Fade from '@material-ui/core/Fade';

import AuthService from 'utils/authService';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ApplicationLayout from '../ApplicationLayout';

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
    !AuthService.getJwt()
      ? (
        <ApplicationLayout
          {...other}
          component={matchProps => (
            <Container maxWidth='sm' className={classes.container}>
              <Fade in appear>
                <div className={classes.content}>
                  <Component {...other} />
                </div>
              </Fade>
            </Container>
          )}
        />
      )
      : <Redirect to={ROUTES.user.home.path()} />
  );
};

SessionLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
};

export const StyledSessionLayout = withStyles(styles)(SessionLayout);

export default compose(
  memo,
  withStyles(styles),
)(SessionLayout);
