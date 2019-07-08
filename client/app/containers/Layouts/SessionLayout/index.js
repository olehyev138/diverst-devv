import React, { memo } from 'react';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { Route } from 'react-router';
import { Redirect } from 'react-router-dom';
import { createStructuredSelector } from 'reselect';
import PropTypes from 'prop-types';

import Container from '@material-ui/core/Container';
import ApplicationLayout from '../ApplicationLayout';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import { selectIsAuthenticated } from 'containers/Shared/App/selectors';

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
  const { classes, isAuthenticated, ...other } = rest;

  return (
    !isAuthenticated
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
      : <Redirect to={ROUTES.user.root.path} />
  );
};

SessionLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
};

const mapStateToProps = createStructuredSelector({
  isAuthenticated: selectIsAuthenticated(),
});

const withConnect = connect(
  mapStateToProps,
);

export default compose(
  withConnect,
  withStyles(styles)
)(SessionLayout);
