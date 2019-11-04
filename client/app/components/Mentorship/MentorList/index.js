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
  const { type } = props;
  const singleType = type.slice(-1);

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
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' },
    { title: 'Email', field: 'email' },
    { title: 'Interests', field: 'interests' },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    console.log(columnId);
    console.log(columns);
    props.handleMentorOrdering({
      orderBy: (columnId === -1) ? 'users.id' : `users.${columns[columnId].field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      <Paper>
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label='Current' />
          <Tab label='Available' />
          {/* <Tab label={intl.formatMessage(messages.index.ongoing, customTexts())} /> */}
        </ResponsiveTabs>
      </Paper>
      <Box mb={1} />
      <DiverstTable
        title={`${props.currentTab === 0 ? 'Your' : 'Available'} ${type.charAt(0).toUpperCase() + type.slice(1)}`}
        handlePagination={props.handleMentorPagination}
        onOrderChange={handleOrderChange}
        isLoading={props.isFetchingUsers}
        rowsPerPage={5}
        params={props.params}
        dataArray={props.users}
        dataTotal={props.userTotal}
        columns={columns}
        actions={[{
          icon: () => props.currentTab === 0 ? (<DeleteIcon />) : (<AssignmentIndIcon />),
          tooltip: props.currentTab === 0 ? 'Remove' : 'Send Request',
          onClick: (_, rowData) => {
            switch (props.currentTab) {
              case 0:
                // eslint-disable-next-line no-restricted-globals,no-alert
                if (confirm('Delete mentorship?')) {
                  const payload = { userId: props.user.id, type };
                  if (type === 'mentors') {
                    payload.mentor_id = rowData.id;
                    payload.mentee_id = props.user.id;
                  } else if (type === 'mentees') {
                    payload.mentor_id = props.user.id;
                    payload.mentee_id = rowData.id;
                  }
                  props.deleteMentorship(payload);
                }
                break;
              case 1:
                handleFormClickOpen(rowData.id);
                break;
              default:
                break;
            }
          }
        }, {
          icon: () => <PersonIcon />,
          tooltip: 'See Profile',
          onClick: (_, rowData) => {
            handleProfileClickOpen(rowData);
          }
        }]}
      />
      <Dialog open={formOpen} onClose={handleFormClose} aria-labelledby='form-dialog-title'>
        <form onSubmit={formik.handleSubmit}>
          <DialogTitle id='form-dialog-title'>
            Mentorship Request
          </DialogTitle>
          <DialogContent>
            <DialogContentText>
              Why do you want this person to mentor you?
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
  })
};

export default compose(
  memo,
  withStyles(styles),
)(MentorList);
