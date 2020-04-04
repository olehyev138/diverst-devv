/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import messages from './messages';

import Events from '../UserEventsPage';
import News from '../UserNewsFeedPage';

import {
  Typography, Button, Grid, Card, CardActions, CardContent, Paper, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import EventsPage from 'containers/Event/EventsPage';
import EventsList from 'components/Group/GroupHome/GroupHomeEventsList';

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
            Upcoming Events
          </Typography>
          <EventsPage
            listComponent={EventsList}
            loaderProps={{
              transitionProps: {
                direction: 'right',
              },
            }}
          />
        </CardContent>
      </Paper>
    );

    return (
      <React.Fragment>
        <Grid container spacing={3}>
          <Grid item xs>
            <h1 className={classes.title}>
              <DiverstFormattedMessage {...messages.events} />
            </h1>
            <Events
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
            <News />
          </Grid>
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
