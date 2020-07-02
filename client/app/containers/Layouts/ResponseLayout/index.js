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
    backgroundColor: theme.palette.primary.main,
  },
  content: {
    height: '100%',
    display: 'flex',
    justifyContent: 'center',
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

const ResponseLayout = (props) => {
  const { classes, children, enterprise, noRedirect, maxWidth, ...other } = props;

  const location = useLocation();

  const authenticated = !!AuthService.getJwt();

  useEffect(() => {
    const query = new URLSearchParams(location.search);
    const enterpriseId = query.get('enterpriseId');

    props.findEnterpriseBegin(enterpriseId ? { enterprise_id: enterpriseId } : {});
  }, []);

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
        <div className={classes.container}>
          <Fade in appear>
            <div className={classes.content}>
              {renderChildrenWithProps(children, { ...other, enterprise })}
            </div>
          </Fade>
        </div>
      )}
    </React.Fragment>
  );
};

ResponseLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  enterprise: PropTypes.object,
  findEnterpriseBegin: PropTypes.func,
  location: PropTypes.object,
  findEnterpriseError: PropTypes.bool,
  noRedirect: PropTypes.bool,
  maxWidth: PropTypes.string,
};

ResponseLayout.defaultProps = {
  maxWidth: 'xl',
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

export const StyledSessionLayout = withStyles(styles)(ResponseLayout);

export default compose(
  memo,
  withConnect,
  withStyles(styles),
)(ResponseLayout);
