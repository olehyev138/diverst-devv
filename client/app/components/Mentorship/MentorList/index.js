/**
 *
 * MentorList Component
 *
 *
 */

import React, {
  memo, useEffect, useRef, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { useFormik } from 'formik';

import { injectIntl, intlShape } from 'react-intl';

import {
  Button, Box, Paper, Tab,
  Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle,
  TextField,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import AssignmentIndIcon from '@material-ui/icons/AssignmentInd';
import PersonIcon from '@material-ui/icons/Person';

import DiverstTable from 'components/Shared/DiverstTable';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

import Profile from 'components/Mentorship/MentorshipUser';
import messages from 'containers/Mentorship/Mentoring/messages';
import appMessages from 'containers/Shared/App/messages';
import dig from 'object-dig';
import { DiverstFormattedMessage } from 'components/Shared/DiverstFormattedMessage';


const styles = theme => ({
  userListItem: {
    width: '100%',
  },
  userListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function MentorList(props, context) {
  const { type, intl } = props;
  const singleType = type.slice(-1);

  const actions = [];
  if (dig(props, 'user', 'id') === props.userSession.id)
    if (type === 'mentors') {
      if (props.currentTab === 0)
        actions.push({
          icon: () => (<DeleteIcon />),
          tooltip: intl.formatMessage(messages.actions.remove),
          onClick: (_, rowData) => {
            // eslint-disable-next-line no-restricted-globals,no-alert
            if (confirm(intl.formatMessage(messages.actions.deleteWarning))) {
              const payload = { userId: props.user.id, type };
              payload.mentor_id = rowData.id;
              payload.mentee_id = props.user.id;
              props.deleteMentorship(payload);
            }
          }
        });
      else if (props.currentTab === 1)
        actions.push({
          icon: () => (<AssignmentIndIcon />),
          tooltip: intl.formatMessage(messages.actions.sendRequest),
          onClick: (_, rowData) => {
            handleFormClickOpen(rowData.id);
          }
        });
    } else if (type === 'mentees')
      if (props.currentTab === 0)
        actions.push({
          icon: () => (<DeleteIcon />),
          tooltip: intl.formatMessage(messages.actions.remove),
          onClick: (_, rowData) => {
            // eslint-disable-next-line no-restricted-globals,no-alert
            if (confirm(intl.formatMessage(messages.actions.deleteWarning))) {
              const payload = { userId: props.user.id, type };
              payload.mentor_id = props.user.id;
              payload.mentee_id = rowData.id;
              props.deleteMentorship(payload);
            }
          }
        });
      else if (props.currentTab === 1)
        actions.push({
          icon: () => (<AssignmentIndIcon />),
          tooltip: intl.formatMessage(messages.actions.sendRequest),
          onClick: (_, rowData) => {
            handleFormClickOpen(rowData.id);
          }
        });


  actions.push({
    icon: () => <PersonIcon />,
    tooltip: intl.formatMessage(messages.actions.viewProfile),
    onClick: (_, rowData) => {
      handleProfileClickOpen(rowData);
    }
  });

  const defaultCreatePayload = {
    mentoring_type: type.slice(0, -1),
    sender_id: props.user.id,
    receiver_id: null,
  };

  const [payload, setPayload] = React.useState(defaultCreatePayload);
  const [formOpen, setFormOpen] = React.useState(false);
  const [profileOpen, setProfileOpen] = React.useState(false);
  const [profile, setProfile] = React.useState();

  const formik = useFormik({
    initialValues: {
      notes: '',
    },
    onSubmit: (values) => {
      props.requestMentorship({ ...values, ...payload });
      handleFormClose();
    },
  });

  const handleFormClickOpen = (receiverId) => {
    setPayload({ ...payload, receiver_id: receiverId });
    setFormOpen(true);
  };

  const handleFormClose = () => {
    setFormOpen(false);
  };

  const handleProfileClickOpen = (userObject) => {
    setProfile(userObject);
    setProfileOpen(true);
  };

  const handleProfileClose = () => {
    setProfileOpen(false);
  };

  const columns = [
    { title: intl.formatMessage(appMessages.person.givenName), field: 'first_name' },
    { title: intl.formatMessage(appMessages.person.familyName), field: 'last_name' },
    { title: intl.formatMessage(appMessages.person.email), field: 'email' },
    { title: intl.formatMessage(messages.columns.interests), field: 'interests', sorting: false },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    props.handleMentorOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `users.${columns[columnId].field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  let title;
  if (props.currentTab === 0 && type === 'mentors')
    title = intl.formatMessage(messages.title.current.mentor);
  else if (props.currentTab === 0 && type === 'mentees')
    title = intl.formatMessage(messages.title.current.mentee);
  else if (props.currentTab === 1 && type === 'mentors')
    title = intl.formatMessage(messages.title.available.mentor);
  else if (props.currentTab === 1 && type === 'mentees')
    title = intl.formatMessage(messages.title.available.mentee);

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label={intl.formatMessage(messages.tabs.current)} />
          { dig(props, 'user', 'id') === props.userSession.id && (
            <Tab label={intl.formatMessage(messages.tabs.available)} />
          )}
        </ResponsiveTabs>
      </Paper>
      <Box mb={1} />
      <DiverstTable
        title={title}
        handlePagination={props.handleMentorPagination}
        onOrderChange={handleOrderChange}
        isLoading={props.isFetchingUsers}
        rowsPerPage={5}
        params={props.params}
        dataArray={props.users}
        dataTotal={props.userTotal}
        columns={columns}
        actions={actions}
      />
      <Dialog open={formOpen} onClose={handleFormClose} aria-labelledby='form-dialog-title'>
        <form onSubmit={formik.handleSubmit}>
          <DialogTitle id='form-dialog-title'>
            Mentorship Request
          </DialogTitle>
          <DialogContent>
            <DialogContentText>
              {type === 'mentors'
                ? (<DiverstFormattedMessage {...messages.actions.mentorWhy} />)
                : (<DiverstFormattedMessage {...messages.actions.menteeWhy} />) }
            </DialogContentText>

            <TextField
              autoFocus
              fullWidth
              margin='dense'
              id='notes'
              name='notes'
              type='text'
              onChange={formik.handleChange}
              value={formik.values.notes}
            />
          </DialogContent>
          <DialogActions>
            <Button
              onClick={() => handleFormClose()}
              color='primary'
            >
              Cancel
            </Button>
            <Button
              type='submit'
              color='primary'
            >
              Submit
            </Button>
          </DialogActions>
        </form>
      </Dialog>
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
  );
}

MentorList.propTypes = {
  type: PropTypes.string,
  classes: PropTypes.object,
  user: PropTypes.object,
  userSession: PropTypes.shape({
    id: PropTypes.number
  }).isRequired,
  users: PropTypes.array,
  userTotal: PropTypes.number,
  isFetchingUsers: PropTypes.bool,
  availableUsers: PropTypes.array,
  availableUserTotal: PropTypes.number,
  isFetchingAvailableUsers: PropTypes.bool,
  userParams: PropTypes.object,
  handleMentorPagination: PropTypes.func,
  handleMentorOrdering: PropTypes.func,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  params: PropTypes.object,
  deleteMentorship: PropTypes.func,
  requestMentorship: PropTypes.func,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  }),
  intl: intlShape.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(MentorList);
