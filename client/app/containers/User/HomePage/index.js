/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FormattedMessage } from 'react-intl';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import injectReducer from 'utils/injectReducer';
import reducer from './reducer';
import messages from './messages';

import {
  Typography, Button, Grid, Card, CardActions, CardContent, Paper
} from '@material-ui/core';
import { fade } from '@material-ui/core/styles/colorManipulator';
import { withStyles } from '@material-ui/core/styles';

import ApplicationHeader from 'components/ApplicationHeader';
import UserLinks from 'components/UserLinks';

const styles = theme => ({});

/* eslint-disable react/prefer-stateless-function */
// TODO: can this be written with a stateless componenet?
export class HomePage extends React.PureComponent {
  render() {
    const { classes } = this.props;

    return (
      <React.Fragment>
        <Grid container spacing={6}>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
        <Grid container spacing={6}>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs={6}>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
          <Grid item xs>
            <Card>
              <CardContent>
                <Typography variant='h5'>
                  Example Content
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      </React.Fragment>
    );
  }
}

HomePage.propTypes = {
  classes: PropTypes.object
};

const mapStateToProps = createStructuredSelector({
});

export function mapDispatchToProps(dispatch, ownProps) {
  return {
    dispatch
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

const withReducer = injectReducer({ key: 'home', reducer });

export default compose(
  withReducer,
  withConnect,
  memo,
  withStyles(styles),
)(HomePage);
