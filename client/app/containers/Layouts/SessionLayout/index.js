import React, { memo, useEffect } from 'react';
import { compose } from 'redux';
import { Redirect } from 'react-router-dom';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';

import { withStyles } from '@material-ui/core/styles';
import { Backdrop, CircularProgress, Container, Fade, Card, CardContent, Typography } from '@material-ui/core';
import ConnectionFailedIcon from '@material-ui/icons/CloudOff';

import { findEnterpriseBegin } from 'containers/Shared/App/actions';

import { selectEnterprise, selectFindEnterpriseError } from 'containers/Shared/App/selectors';

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
  connectFailedCardContent: {
    textAlign: 'center',
    padding: 20,
    paddingBottom: 24,
  },
  connectFailedIcon: {
    fontSize: 64,
  },
});

const SessionLayout = ({ component: Component, ...props }) => {
  const { classes, ...other } = props;

  const authenticated = !!AuthService.getJwt();

  useEffect(() => {
    if (authenticated) return;

    const query = new URLSearchParams(props.location.search);
    const enterpriseId = query.get('enterpriseId');

    if (!props.enterprise)
      props.findEnterpriseBegin(enterpriseId ? { enterprise_id: enterpriseId } : {});
  }, []);

  if (authenticated) return <Redirect to={ROUTES.user.home.path()} />;

  return (
    <ApplicationLayout
      {...other}
      component={matchProps => (
        <React.Fragment>
          <Backdrop open={!props.enterprise}>
            {!props.findEnterpriseError && (
              <CircularProgress
                color='secondary'
                size={60}
                thickness={1}
              />
            )}
            {props.findEnterpriseError && (
              <Fade in appear>
                <Card elevation={24}>
                  <CardContent className={classes.connectFailedCardContent}>
                    <ConnectionFailedIcon color='primary' className={classes.connectFailedIcon} />
                    <br />
                    <br />
                    <Typography variant='h6' color='primary'>
                      Unable to connect to server
                    </Typography>
                  </CardContent>
                </Card>
              </Fade>
            )}
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
  findEnterpriseError: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
  findEnterpriseError: selectFindEnterpriseError(),
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
