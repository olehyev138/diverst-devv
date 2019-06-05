/**
 *
 * LandingPage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FormattedMessage } from 'react-intl';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import makeSelectLandingPage from './selectors';
import reducer from './reducer';
import saga from './saga';

// TODO
import messages from './messages';

import { Link } from 'react-router-dom';

import {
  Typography, AppBar, Toolbar, Grid, Button
} from '@material-ui/core';

import logo from 'images/favicon.png';

import './index.css';

export function LandingPage() {
  useInjectReducer({ key: 'landingPage', reducer });
  useInjectSaga({ key: 'landingPage', saga });

  return (
    <AppBar position='static' style={{ background: 'transparent', boxShadow: 'none' }}>
      <Toolbar>
        <Grid container>
          <Grid item>
            <img src={logo} alt='diverst Logo' />
          </Grid>

          <Grid item style={{ marginTop: 15, marginLeft: 15, flex: 1 }}>
            <Typography variant='h4' color='primary'>
              Diverst
            </Typography>
          </Grid>

          <Grid item>
            <div>
              <Button color='primary'>
                <Link to='/login'>Login</Link>
              </Button>
            </div>
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
