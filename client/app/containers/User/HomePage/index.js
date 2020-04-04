/**
 *
 * HomePage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import messages from './messages';

import { EventsPage } from '../UserEventsPage';
import { NewsFeedPage } from '../UserNewsFeedPage';

import {
  Typography, Button, Grid, Card, CardActions, CardContent, Paper, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { createStructuredSelector } from 'reselect';
import {
  selectEventsTotal, selectIsLoadingEvents,
  selectIsLoadingPosts,
  selectPaginatedEvents,
  selectPaginatedPosts,
  selectPostsTotal
} from 'containers/User/selectors';
import { selectPermissions, selectUser } from 'containers/Shared/App/selectors';
import { getUserEventsBegin, getUserPostsBegin, userUnmount } from 'containers/User/actions';
import { likeNewsItemBegin, unlikeNewsItemBegin } from 'containers/Shared/Like/actions';
import { connect } from 'react-redux';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';

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

const newsMapStateToProps = createStructuredSelector({
  newsItems: selectPaginatedPosts(),
  newsItemsTotal: selectPostsTotal(),
  currentUser: selectUser(),
  isLoading: selectIsLoadingPosts(),
  permissions: selectPermissions(),
});

const newsMapDispatchToProps = {
  getUserPostsBegin,
  userUnmount,
  likeNewsItemBegin,
  unlikeNewsItemBegin
};

const newsWithConnect = connect(
  newsMapStateToProps,
  newsMapDispatchToProps,
);

const News = compose(
  newsWithConnect,
  memo,
)(Conditional(
  NewsFeedPage,
  ['permissions.news_view'],
  null,
  'You don\'t have permission view news'
));

const eventMapStateToProps = createStructuredSelector({
  events: selectPaginatedEvents(),
  eventsTotal: selectEventsTotal(),
  isLoading: selectIsLoadingEvents(),
  currentSession: selectUser(),
  permissions: selectPermissions(),
});

const eventMapDispatchToProps = {
  getUserEventsBegin,
  userUnmount,
};

const eventWithConnect = connect(
  eventMapStateToProps,
  eventMapDispatchToProps,
);

const Events = compose(
  eventWithConnect,
  memo,
)(Conditional(
  EventsPage,
  ['permissions.events_view'],
  null,
  'You don\'t have permission view events'
));

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
