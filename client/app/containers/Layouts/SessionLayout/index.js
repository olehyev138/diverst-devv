import React, { memo, useEffect, useContext } from 'react';
import { compose } from 'redux';
import { Redirect, useLocation } from 'react-router-dom';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';

import { withStyles } from '@material-ui/core/styles';
import { Backdrop, CircularProgress, Container, Fade, Card, CardContent, Typography } from '@material-ui/core';
import ConnectionFailedIcon from '@material-ui/icons/CloudOff';

import { findEnterpriseBegin } from 'containers/Shared/App/actions';

import { selectEnterprise, selectFindEnterpriseError } from 'containers/Shared/App/selectors';

import AuthService from 'utils/authService';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Shared/App/messages';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import { renderChildrenWithProps } from 'utils/componentHelpers';

const styles = theme => ({
  container: {
    height: '100%',
  },
  containerWithColor: {
    height: '100%',
    backgroundColor: theme.palette.primary.main,
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

const SessionLayout = (props) => {
  const { classes, children, enterprise, noRedirect, maxWidth, ...other } = props;

  const location = useLocation();

  const authenticated = !!AuthService.getJwt();

  useEffect(() => {
    if (authenticated && !noRedirect) return;

    const query = new URLSearchParams(location.search);
    const enterpriseId = query.get('enterpriseId');

    props.findEnterpriseBegin(enterpriseId ? { enterprise_id: enterpriseId } : {});
  }, []);

  if (authenticated && !noRedirect) return <Redirect to={ROUTES.user.home.path()} />;

  const container = noRedirect ? classes.containerWithColor : classes.container;

  return (
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
                  <DiverstFormattedMessage {...messages.errors.findEnterprise} />
                </Typography>
              </CardContent>
            </Card>
          </Fade>
        )}
      </Backdrop>
      {props.enterprise && (
        <Container maxWidth={maxWidth} className={container}>
          <Fade in appear>
            <div className={classes.content}>
              {renderChildrenWithProps(children, { ...other, enterprise })}
            </div>
          </Fade>
        </Container>
      )}
    </React.Fragment>
  );
};

SessionLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  enterprise: PropTypes.object,
  findEnterpriseBegin: PropTypes.func,
  location: PropTypes.object,
  findEnterpriseError: PropTypes.bool,
  noRedirect: PropTypes.bool,
  maxWidth: PropTypes.string,
};

SessionLayout.defaultProps = {
  maxWidth: 'sm',
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
