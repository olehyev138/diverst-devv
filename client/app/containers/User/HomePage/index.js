/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import messages from './messages';

import EventsPage from '../UserEventsPage';
import NewsPage from '../UserNewsFeedPage';
import SponsorCard from 'components/Branding/Sponsor/SponsorCard';

import {
  Typography, Button, Grid, Card, CardActions, CardContent, Paper, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

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
              <DiverstFormattedMessage {...messages.events} />
            </h1>
            <EventsPage
              loaderProps={{
                transitionProps: {
                  direction: 'right',
                },
              }}
            />
          </Grid>
          <Grid item xs='auto'>
            <Divider orientation='vertical' />
          </Grid>
          <Grid item xs>
            <h1 className={classes.title}>
              <DiverstFormattedMessage {...messages.news} />
            </h1>
            <NewsPage />
          </Grid>
        </Grid>
        <Grid item xs>
          <SponsorCard
            type='enterprise'
            currentGroup={null}
          />
        </Grid>
      </React.Fragment>
    );
  }
}

HomePage.propTypes = {
  classes: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles),
)(HomePage);
