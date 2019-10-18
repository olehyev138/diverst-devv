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
import { FormattedMessage } from 'react-intl';
import messages from 'containers/User/messages';
import appMessages from 'containers/Shared/App/messages';
import mentorMessages from 'containers/Mentorship/messages';

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
                Profile
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.edit.path(user.id)}
                component={WrappedNavLink}
                color='primary'
                size='large'
              >
                Edit Profile
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                Mentors
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                Mentees
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                Requests
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                Schedule A Session
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                Upcoming Sessions
              </Button>
            </CardContent>
            <CardContent>
              <Button
                to={ROUTES.user.mentorship.show.path(user.id)}
                component={WrappedNavLink}
              >
                Session Feedback
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
