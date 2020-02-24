/**
 *
 * LandingPage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import makeSelectLandingPage from 'containers/Session/LandingPage/selectors';
import reducer from 'containers/Session/LandingPage/reducer';
import saga from 'containers/Session/LandingPage/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

// TODO
import messages from 'containers/Session/LandingPage/messages';

import { Link } from 'react-router-dom';

import {
  Typography, AppBar, Toolbar, Grid, Button
} from '@material-ui/core';

import logo from 'images/favicon.png';

import 'containers/Session/LandingPage/index.css';
import { FormattedMessage } from 'react-intl';

export function LandingPage() {
  useInjectReducer({ key: 'landingPage', reducer });
  useInjectSaga({ key: 'landingPage', saga });

  return (
    <AppBar position='static' style={{ background: 'transparent', boxShadow: 'none' }}>
      <Toolbar>
        <Grid container>
          <Grid item>
            <img src={logo} alt='Diverst Logo' />
          </Grid>

          <Grid item style={{ marginTop: 15, marginLeft: 15, flex: 1 }}>
            <Typography variant='h4' color='primary'>
              Diverst
            </Typography>
          </Grid>

          <Grid item>
            <React.Fragment>
              <Button color='primary'>
                <Link to={ROUTES.session.login.path()}>{<FormattedMessage {...messages.login} />}</Link>
              </Button>
            </React.Fragment>
          </Grid>
        </Grid>
      </Toolbar>
    </AppBar>
  );
}

LandingPage.propTypes = {
  dispatch: PropTypes.func.isRequired,
};

const mapStateToProps = createStructuredSelector({
  landingPage: makeSelectLandingPage(),
});

function mapDispatchToProps(dispatch) {
  return {
    dispatch,
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(LandingPage);
