import React, { memo, useEffect } from 'react';
import { compose } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';

import { withStyles } from '@material-ui/core/styles';
import { Backdrop, CircularProgress, Container, Fade } from '@material-ui/core';

import { findEnterpriseBegin } from 'containers/Shared/App/actions';

import { selectEnterprise } from 'containers/Shared/App/selectors';

import ApplicationLayout from '../ApplicationLayout';

import AuthService from 'utils/authService';
import { ROUTES } from 'containers/Shared/Routes/constants';

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

const SessionLayout = ({ component: Component, ...props }) => {
  const { classes, ...other } = props;

  const authenticated = !!AuthService.getJwt();

  useEffect(() => {
    if (authenticated) return;

    const query = new URLSearchParams(props.location.search);
    const enterpriseId = query.get('enterpriseId');

    props.findEnterpriseBegin(enterpriseId ? { enterprise_id: enterpriseId } : {});
  }, []);

  if (authenticated) return <Redirect to={ROUTES.user.home.path()} />;

  return (
    <ApplicationLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <Backdrop open={!props.enterprise}>
            <CircularProgress
              color='secondary'
              size={60}
              thickness={1}
            />
          </Backdrop>
          {props.enterprise && (
            <Container maxWidth='sm' className={classes.container}>
              <Fade in appear>
                <div className={classes.content}>
                  <Component {...other} enterprise={props.enterprise} />
                </div>
              </Fade>
            </Container>
          )}
        </React.Fragment>
      )}
    />
  );
};

SessionLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  enterprise: PropTypes.object,
  findEnterpriseBegin: PropTypes.func,
  location: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
});

const mapDispatchToProps = {
  findEnterpriseBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export const StyledSessionLayout = withStyles(styles)(SessionLayout);

export default compose(
  memo,
  withConnect,
  withStyles(styles),
)(SessionLayout);
