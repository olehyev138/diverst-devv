/**
 *
 * Session Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { FormattedMessage, injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';
import {
  Button, Card, CardActions, CardContent, TextField,
  Divider, Grid, FormControlLabel, Switch, FormControl, Typography, Paper
} from '@material-ui/core';

import messages from 'containers/Mentorship/Session/messages';

import { DateTime } from 'luxon';

import classNames from 'classnames';

import DeleteIcon from '@material-ui/core/SvgIcon/SvgIcon';
import EditIcon from '@material-ui/icons/Edit';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { formatDateTimeString } from 'components/../utils/dateTimeHelpers';
import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import ErrorBoundary from "../../../containers/Shared/ErrorBoundary";

const styles = theme => ({
  padding: {
    padding: theme.spacing(3, 2),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
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
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
});

/* eslint-disable object-curly-newline */
export function Session(props) {
  const { session, classes, loggedUser } = props;

  return (
    <DiverstShowLoader isLoading={props.isFetchingSession} isError={!props.isFetchingSession && !session}>
      {session && (
        <React.Fragment>
          <Grid container spacing={1}>
            <Grid item>
              <Typography color='primary' variant='h5' component='h2' className={classes.title}>
                {session.name}
              </Typography>
            </Grid>
            <Grid item sm>
              { loggedUser.id === session.creator_id && (
                <React.Fragment>
                  <Button
                    variant='contained'
                    size='large'
                    color='primary'
                    className={classNames(classes.buttons, classes.deleteButton)}
                    startIcon={<DeleteIcon />}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm('Delete session?'))
                        props.deleteSession({
                          id: session.id,
                        });
                    }}
                  >
                    <DiverstFormattedMessage {...messages.index.delete} />
                  </Button>
                  <Button
                    component={WrappedNavLink}
                    to={props.links.sessionEdit(session.id)}
                    variant='contained'
                    size='large'
                    color='primary'
                    className={classes.buttons}
                    startIcon={<EditIcon />}
                  >
                    <DiverstFormattedMessage {...messages.index.edit} />
                  </Button>
                </React.Fragment>
              )}

            </Grid>
          </Grid>
          <Paper className={classes.padding}>
            <Typography className={classes.dataHeaders}>
              <DiverstFormattedMessage {...messages.show.dateAndTime} />
            </Typography>
            <Typography variant='overline'>From</Typography>
            <Typography color='textSecondary'>{formatDateTimeString(session.start, DateTime.DATETIME_FULL)}</Typography>
            <Typography variant='overline'>To</Typography>
            <Typography color='textSecondary' className={classes.data}>{formatDateTimeString(session.end, DateTime.DATETIME_FULL)}</Typography>

            {session.notes && (
              <React.Fragment>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.form.notes} />
                </Typography>
                <Typography color='textSecondary' className={classes.data}>
                  {session.notes}
                </Typography>
              </React.Fragment>
            )}
          </Paper>
        </React.Fragment>
      )}
    </DiverstShowLoader>
  );
}

Session.propTypes = {
  session: PropTypes.object,
  user: PropTypes.object,
  loggedUser: PropTypes.object,
  classes: PropTypes.object,
  links: PropTypes.object,

  users: PropTypes.array,

  isSessionsLoading: PropTypes.bool,
  isFetchingSession: PropTypes.bool,
  isCommitting: PropTypes.bool,

  deleteSession: PropTypes.func,
  acceptInvite: PropTypes.func,
  rejectInvite: PropTypes.func,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(Session);
