import React, { memo } from 'react';

import { compose } from 'redux/';
import PropTypes from 'prop-types';
import dig from 'object-dig';

import {
  Paper, Typography, Grid, Button, Divider, CardContent, Card, Box, List, ListItem,
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';

import classNames from 'classnames';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { height } from '@material-ui/system';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import userMessages from 'containers/User/messages';
import appMessages from 'containers/Shared/App/messages';
import messages from 'containers/Mentorship/messages';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { DateTime } from 'luxon';

import ArrowRightIcon from '@material-ui/icons/ArrowRight';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
    margin: theme.spacing(1, 0),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
  card: {
    minHeight: 1000,
  },
});

export function MentorshipMenu(props) {
  const user = dig(props, 'user');
  const { classes } = props;

  return (
    <React.Fragment>
      <Card className={classes.card}>
        {(user) ? (
          <React.Fragment>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
                color='primary'
                size='large'
              >
                <DiverstFormattedMessage {...messages.menu.profile} />
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.edit.path(user.id)}
                component={WrappedNavLink}
                color='primary'
                size='large'
              >
                <DiverstFormattedMessage {...messages.menu.editProfile} />
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.mentors.path(user.id)}
                component={WrappedNavLink}
                color='primary'
                size='large'
              >
                <DiverstFormattedMessage {...messages.menu.mentors} />
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.menu.mentees} />
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.menu.requests} />
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.menu.schedule} />
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.menu.upcoming} />
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                <DiverstFormattedMessage {...messages.menu.feedback} />
              </Button>
            </CardContent>
          </React.Fragment>
        ) : (
          <React.Fragment />
        )}
      </Card>
    </React.Fragment>
  );
}

MentorshipMenu.propTypes = {
  user: PropTypes.object,
  classes: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(MentorshipMenu);
