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
import EventsList from 'components/Event/HomeEventsList';
import NewsFeed from 'components/News/HomeNewsList';

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

    const events = (
      <Paper>
        <CardContent>
          <Typography variant='h5' className={classes.title}>
            <DiverstFormattedMessage {...messages.events} />
          </Typography>
          <Events
            listComponent={EventsList}
            readonly
            loaderProps={{
              transitionProps: {
                direction: 'right',
              },
            }}
          />
        </CardContent>
      </Paper>
    );

    const news = (
      <Paper>
        <CardContent>
          <Typography variant='h5' className={classes.title}>
            <DiverstFormattedMessage {...messages.news} />
          </Typography>
          <News
            listComponent={NewsFeed}
            readonly
          />
        </CardContent>
      </Paper>
    );

    return (
      <React.Fragment>
        <Grid container spacing={3}>
          <Grid item xs>
            {events}
          </Grid>
          <Grid item xs>
            {news}
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
