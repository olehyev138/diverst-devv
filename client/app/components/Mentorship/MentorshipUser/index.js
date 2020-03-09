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
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/messages';
import appMessages from 'containers/Shared/App/messages';
import mentorMessages from 'containers/Mentorship/messages';

import { DateTime } from 'luxon';

import ArrowRightIcon from '@material-ui/icons/ArrowRight';
import MentorshipMenu from 'components/Mentorship/MentorshipMenu';

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
    margin: theme.spacing(1, 0),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    // paddingBottom: theme.spacing(3),
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    '&:not(:last-of-type)': { // Prevent last data item from adding bottom padding
      paddingBottom: theme.spacing(3),
    },
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
});

function timeToSimpleString(time) {
  return DateTime.fromISO(time, { setZone: true }).toLocaleString(DateTime.TIME_SIMPLE);
}

export function Profile(props) {
  const { classes } = props;
  const user = dig(props, 'user');
  const fieldData = dig(props, 'fieldData');

  return (
    <React.Fragment>
      {(user) ? (
        <React.Fragment>
          { /* BASIC INFO */ }
          <Paper elevation={3}>
            <CardContent>
              <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                {user.name}
              </Typography>
            </CardContent>
          </Paper>
          <Box mb={2} />
          <Paper elevation={3}>
            <CardContent>
              <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                {<DiverstFormattedMessage {...messages.email} />}
              </Typography>
              <Typography color='secondary' component='h2' className={classes.data}>
                {user.email}
              </Typography>
            </CardContent>
            <Divider />
            <CardContent>
              <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                {<DiverstFormattedMessage {...messages.biography} />}
              </Typography>
              {(user.biography || 'None').split('\n').map((text, i) => (
                // eslint-disable-next-line react/no-array-index-key
                <Typography color='secondary' component='h2' key={i}>
                  {text}
                </Typography>
              ))}
            </CardContent>
            <Divider />
            <CardContent>
              <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                {<DiverstFormattedMessage {...messages.time_zone} />}
              </Typography>
              <Typography color='secondary' component='h2' className={classes.data}>
                {user.time_zone || 'UTC'}
              </Typography>
            </CardContent>
          </Paper>
          <Box mb={2} />
          { /* MENTORSHIP INFO */ }
          <Paper elevation={3}>
            { user.mentorship_description && (
              <CardContent>
                <Grid container spacing={1}>
                  <Grid item xs>
                    <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                      <DiverstFormattedMessage {...mentorMessages.long.goals} />
                    </Typography>
                    <Typography color='secondary' component='h2' className={classes.data}>
                      { user.mentorship_description }
                    </Typography>
                  </Grid>
                </Grid>
              </CardContent>
            )}
            <Divider />
            <CardContent>
              <Grid container spacing={1}>
                <Grid item xs>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    <DiverstFormattedMessage {...mentorMessages.mentor.isA.neutral} />
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    {user.mentor ? (
                      <DiverstFormattedMessage {...appMessages.confirmation.yes} />
                    ) : (
                      <DiverstFormattedMessage {...appMessages.confirmation.no} />
                    )}
                  </Typography>
                </Grid>
                <Grid item xs>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    <DiverstFormattedMessage {...mentorMessages.mentee.isA.neutral} />
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    {user.mentee ? (
                      <DiverstFormattedMessage {...appMessages.confirmation.yes} />
                    ) : (
                      <DiverstFormattedMessage {...appMessages.confirmation.no} />
                    )}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
            <Divider />
            <CardContent>
              <Grid container spacing={1}>
                <Grid item xs>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    <DiverstFormattedMessage {...mentorMessages.accepting.mentors} />
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    {user.accepting_mentor_requests ? (
                      <DiverstFormattedMessage {...appMessages.confirmation.yes} />
                    ) : (
                      <DiverstFormattedMessage {...appMessages.confirmation.no} />
                    )}
                  </Typography>
                </Grid>
                <Grid item xs>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    <DiverstFormattedMessage {...mentorMessages.accepting.mentees} />
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    {user.accepting_mentee_requests ? (
                      <DiverstFormattedMessage {...appMessages.confirmation.yes} />
                    ) : (
                      <DiverstFormattedMessage {...appMessages.confirmation.no} />
                    )}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
            <Divider />
            <CardContent>
              <Grid container spacing={1}>
                <Grid item xs>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    <DiverstFormattedMessage {...mentorMessages.long.interests} />
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    {user.mentoring_interests && user.mentoring_interests.length > 0 && (
                      <List>
                        {user.mentoring_interests.map((interest, i) => (
                          // eslint-disable-next-line react/no-array-index-key
                          <ListItem dense key={`fieldData${interest.id}-${i}`}>
                            <ArrowRightIcon fontSize='small' />
                            {`${interest.name}`}
                          </ListItem>
                        ))}
                      </List>
                    )}
                    {user.mentoring_interests && user.mentoring_interests.length <= 0 && (
                      'None'
                    )}
                  </Typography>
                </Grid>
                <Grid item xs>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    <DiverstFormattedMessage {...mentorMessages.long.types} />
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    {user.mentoring_types && user.mentoring_types.length > 0 && (
                      <List>
                        {user.mentoring_types.map((type, i) => (
                          // eslint-disable-next-line react/no-array-index-key
                          <ListItem dense key={`fieldData${type.id}-${i}`}>
                            <ArrowRightIcon fontSize='small' />
                            {`${type.name}`}
                          </ListItem>
                        ))}
                      </List>
                    )}
                    {user.mentoring_types && user.mentoring_types.length <= 0 && (
                      'None'
                    )}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
            <Divider />
            <CardContent>
              <Grid container spacing={1}>
                <Grid item xs>
                  <Typography color='primary' variant='h6' component='h2' className={classes.dataHeaders}>
                    <DiverstFormattedMessage {...mentorMessages.long.availability} />
                  </Typography>
                  <Typography color='secondary' component='h2' className={classes.data}>
                    <Grid container>
                      <Grid item xs>
                        <DiverstFormattedMessage {...mentorMessages.long.your_time_zone} />
                      </Grid>
                      <Grid item xs>
                        <DiverstFormattedMessage {...mentorMessages.long.their_time_zone} />
                      </Grid>
                    </Grid>
                    {user.availabilities && user.availabilities.length > 0 && (
                      <List>
                        {user.availabilities.map((time, i) => (
                          // eslint-disable-next-line react/no-array-index-key
                          <Grid container key={`fieldData${time.id}-${i}`}>
                            <ListItem dense>
                              <Grid item xs>
                                <ArrowRightIcon fontSize='small' />
                                <DiverstFormattedMessage {...appMessages.days_of_week[time.day]} />
                                &nbsp;&nbsp;
                                {`${timeToSimpleString(time.local_start)} − ${timeToSimpleString(time.local_end)}`}
                              </Grid>
                              <Grid item xs>
                                <ArrowRightIcon fontSize='small' />
                                <DiverstFormattedMessage {...appMessages.days_of_week[time.day]} />
                                &nbsp;&nbsp;
                                {`${timeToSimpleString(time.start)} − ${timeToSimpleString(time.end)}`}
                              </Grid>
                            </ListItem>
                          </Grid>
                        ))}
                      </List>
                    )}
                    {user.availabilities && user.availabilities.length <= 0 && (
                      'None'
                    )}
                  </Typography>
                </Grid>
              </Grid>
            </CardContent>
          </Paper>
        </React.Fragment>
      ) : <React.Fragment />}
    </React.Fragment>
  );
}

Profile.propTypes = {
  deleteEventBegin: PropTypes.func,
  classes: PropTypes.object,
  event: PropTypes.object,
  currentUserId: PropTypes.number,
  links: PropTypes.shape({
    userEdit: PropTypes.func,
  })
};

export default compose(
  memo,
  withStyles(styles)
)(Profile);
