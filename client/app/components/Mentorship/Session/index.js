/**
 *
 * Session Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';
import {
  Button,
  Grid,
  Typography,
  Paper,
  Box,
  Link,
  DialogContent,
  DialogActions,
  Dialog
} from '@material-ui/core';

import messages from 'containers/Mentorship/Session/messages';

import { DateTime } from 'luxon';

import classNames from 'classnames';

import DeleteIcon from '@material-ui/icons/Delete';
import EditIcon from '@material-ui/icons/Edit';
import OpenInNew from '@material-ui/icons/OpenInNew';
import PersonIcon from '@material-ui/icons/Person';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { formatDateTimeString } from 'components/../utils/dateTimeHelpers';
import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import appMessages from 'containers/Shared/App/messages';
import DiverstTable from 'components/Shared/DiverstTable';
import Profile from 'components/Mentorship/MentorshipUser';

const styles = theme => ({
  link: {
    textDecoration: 'none !important',
  },
  padding: {
    padding: theme.spacing(3, 2),
  },
  title: {
    textAlign: 'center',
    fontWeight: 'bold',
    paddingBottom: theme.spacing(3),
  },
  dataHeadersBig: {
    fontWeight: 'bold',
    fontSize: 30,
  },
  dataBig: {
    fontWeight: 'bold',
    fontSize: 30,
  },
  dataHeaders: {
    paddingBottom: theme.spacing(1),
  },
  data: {
    paddingBottom: theme.spacing(3),
  },
  buttons: {
    marginLeft: 20,
    float: 'right',
  },
  deleteButton: {
    backgroundColor: theme.palette.error.main,
  },
  linkButton: {
    'text-transform': 'none !important',
    'background-color': 'transparent',
    border: 'none',
    text_transform: 'none',
    cursor: 'pointer',
    display: 'inline',
    margin: 0,
    padding: 0,
  }
});

/* eslint-disable object-curly-newline */
export function Session(props) {
  const { session, classes, loggedUser, intl } = props;

  const [profileOpen, setProfileOpen] = React.useState(false);
  const [profile, setProfile] = React.useState();

  const handleProfileClickOpen = (userObject) => {
    setProfile(userObject);
    setProfileOpen(true);
  };

  const handleProfileClose = () => {
    setProfileOpen(false);
  };

  const columns = [
    { title: intl.formatMessage(appMessages.person.givenName),
      field: 'user.first_name',
      query_field: 'users.first_name'
    },
    { title: intl.formatMessage(appMessages.person.familyName),
      field: 'user.last_name',
      query_field: 'users.last_name'
    },
    { title: intl.formatMessage(messages.show.role),
      field: 'role',
      query_field: 'role' },
    {
      title: intl.formatMessage(messages.show.status),
      field: 'status',
      query_field: 'status',
      lookup: {
        leading: intl.formatMessage(messages.show.leading),
        pending: intl.formatMessage(messages.show.pending),
        accepted: intl.formatMessage(messages.show.accepted),
        declined: intl.formatMessage(messages.show.rejected),
      }
    },
  ];

  const actions = [];
  actions.push({
    icon: () => <PersonIcon />,
    tooltip: intl.formatMessage(messages.show.viewProfile),
    onClick: (_, rowData) => {
      handleProfileClickOpen(rowData.user);
    }
  });

  const handleOrderChange = (columnId, orderDir) => {
    props.handleParticipantOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };


  return (
    <DiverstShowLoader isLoading={props.isFetchingSession} isError={!props.isFetchingSession && !session}>
      {session && (
        <React.Fragment>
          <Grid container spacing={1}>
            <Grid item sm>
              { loggedUser.user_id === session.creator_id && (
                <React.Fragment>
                  <Button
                    variant='contained'
                    size='large'
                    color='primary'
                    className={classNames(classes.buttons, classes.deleteButton)}
                    startIcon={<DeleteIcon />}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm(intl.formatMessage(messages.show.confirm.delete)))
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
          <Box mb={1} />
          <Paper className={classes.padding}>

            { /* ACCEPT / DECLINE Buttons */ }
            {session.creator_id !== loggedUser.user_id
            && session.current_user_session
            && session.current_user_session.status === 'pending'
            && (
              <React.Fragment>
                <Button
                  variant='contained'
                  size='large'
                  color='primary'
                  className={classNames(classes.buttons, classes.deleteButton)}
                  onClick={() => {
                    /* eslint-disable-next-line no-alert, no-restricted-globals */
                    if (confirm(intl.formatMessage(messages.show.confirm.decline)))
                      props.declineInvite({
                        user_id: session.current_user_session.user_id,
                        session_id: session.id
                      });
                  }}
                >
                  <DiverstFormattedMessage {...messages.show.reject} />
                </Button>
                <Button
                  variant='contained'
                  size='large'
                  color='primary'
                  className={classNames(classes.buttons)}
                  onClick={() => {
                    /* eslint-disable-next-line no-alert, no-restricted-globals */
                    if (confirm(intl.formatMessage(messages.show.confirm.accept)))
                      props.acceptInvite({
                        user_id: session.current_user_session.user_id,
                        session_id: session.id
                      });
                  }}
                >
                  <DiverstFormattedMessage {...messages.show.accept} />
                </Button>
              </React.Fragment>
            )}

            <React.Fragment>
              <Typography className={classes.dataHeadersBig}>
                <DiverstFormattedMessage {...messages.show.leadedBy} />
              </Typography>
              <Button className={classes.linkButton} onClick={() => handleProfileClickOpen(session.creator)}>
                <Typography color='textSecondary' className={classes.dataBig}>
                  {session.creator.name}
                </Typography>
              </Button>
            </React.Fragment>

            <Box mb={3} />

            <Typography className={classes.dataHeaders}>
              <DiverstFormattedMessage {...messages.show.dateAndTime} />
            </Typography>
            <Typography variant='overline'><DiverstFormattedMessage {...messages.show.from} /></Typography>
            <Typography color='textSecondary'>{formatDateTimeString(session.start, DateTime.DATETIME_FULL)}</Typography>
            <Typography variant='overline'><DiverstFormattedMessage {...messages.show.to} /></Typography>
            <Typography color='textSecondary' className={classes.data}>{formatDateTimeString(session.end, DateTime.DATETIME_FULL)}</Typography>

            { /* Misc Fields */ }
            {session.link && (
              <React.Fragment>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.show.link} />
                </Typography>
                <Typography color='textSecondary' className={classes.data}>
                  <Link
                    href={session.link}
                    target='_blank'
                    rel='noopener'
                    className={classes.link}
                  >
                    {session.link}
                    <OpenInNew color='secondary' fontSize='small' />
                  </Link>
                </Typography>
              </React.Fragment>
            )}

            {session.medium && (
              <React.Fragment>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.show.medium} />
                </Typography>
                <Typography color='textSecondary' className={classes.data}>
                  {session.medium}
                </Typography>
              </React.Fragment>
            )}

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

            {session.interests && (
              <React.Fragment>
                <Typography className={classes.dataHeaders}>
                  <DiverstFormattedMessage {...messages.show.topics} />
                </Typography>
                <Typography color='textSecondary' className={classes.data}>
                  {session.interests}
                </Typography>
              </React.Fragment>
            )}

            <Box mb={1} />

            {session.users && (
              <React.Fragment>
                <DiverstTable
                  title={intl.formatMessage(messages.show.title)}
                  handlePagination={props.handleParticipantPagination}
                  onOrderChange={handleOrderChange}
                  isLoading={props.isFetchingSessions}
                  rowsPerPage={5}
                  params={props.params}
                  dataArray={props.users}
                  dataTotal={props.usersTotal}
                  columns={columns}
                  actions={actions}
                  tableOptions={{
                    rowStyle: (rowData) => {
                      let colour;
                      switch (rowData.status) {
                        case 'accepted':
                          colour = '#EFE';
                          break;
                        case 'declined':
                          colour = '#FEE';
                          break;
                        case 'leading':
                          colour = '#EEF';
                          break;
                        default:
                          colour = '#FFF';
                          break;
                      }
                      return {
                        backgroundColor: colour
                      };
                    }
                  }}
                />
                <Dialog
                  open={profileOpen}
                  fullWidth
                  maxWidth='md'
                  onClose={handleProfileClose}
                  aria-labelledby='alert-dialog-slide-title'
                  aria-describedby='alert-dialog-slide-description'
                >
                  <DialogContent>
                    <Profile
                      user={profile}
                    />
                  </DialogContent>
                  <DialogActions>
                    <Button onClick={handleProfileClose} color='primary'>
                      Close
                    </Button>
                  </DialogActions>
                </Dialog>
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
  usersTotal: PropTypes.array,

  isFetchingSessions: PropTypes.bool,
  isFetchingSession: PropTypes.bool,
  isCommitting: PropTypes.bool,

  params: PropTypes.object,
  handleParticipantPagination: PropTypes.func,
  handleParticipantOrdering: PropTypes.func,

  deleteSession: PropTypes.func,
  acceptInvite: PropTypes.func,
  declineInvite: PropTypes.func,

  intl: intlShape.isRequired,
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles)
)(Session);
