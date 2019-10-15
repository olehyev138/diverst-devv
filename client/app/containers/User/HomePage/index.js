/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import injectReducer from 'utils/injectReducer';
import reducer from './reducer';
import messages from './messages';

import EventsPage from '../UserEventsPage/index';
import NewsPage from '../UserNewsFeedPage';

import {
  Typography, Button, Grid, Card, CardActions, CardContent, Paper, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(1),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
});

/* eslint-disable react/prefer-stateless-function */
export class HomePage extends React.PureComponent {
  render() {
    const { classes } = this.props;

    return (
      <React.Fragment>
        <Grid container spacing={3}>
          <Grid item xs>
            <h1 className={classes.title}>
              <FormattedMessage {...messages.events} />
            </h1>
            <EventsPage />
          </Grid>
          <Grid item xs='auto'>
            <Divider orientation='vertical' />
          </Grid>
          <Grid item xs>
            <h1 className={classes.title}>
              <FormattedMessage {...messages.news} />
            </h1>
            <NewsPage />
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
