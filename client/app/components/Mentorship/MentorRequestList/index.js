/**
 *
 * MentorRequestList Component
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

import PersonIcon from '@material-ui/icons/Person';
import CheckIcon from '@material-ui/icons/Check';
import ClearIcon from '@material-ui/icons/Clear';
import DeleteIcon from '@material-ui/icons/Delete';

import DiverstTable from 'components/Shared/DiverstTable';

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

export function MentorRequestList(props, context) {
  // type = 'incoming' or 'outgoing'
  const { type } = props;

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
    { title: 'First Name',
      field: `${type === 'incoming' ? 'sender' : 'receiver'}.first_name`,
      query_field: 'users.first_name'
    },
    { title: 'Last Name',
      field: `${type === 'incoming' ? 'sender' : 'receiver'}.last_name`,
      query_field: 'users.last_name'
    },
    { title: 'Notes', field: 'notes', query_field: 'notes' },
    { title: 'Type', field: 'mentoring_type', query_field: 'mentoring_type' },
    { title: 'Status', field: 'status', query_field: 'status' },
  ];

  const actions = [];
  if (type === 'incoming') {
    actions.push({
      icon: () => (<CheckIcon />),
      tooltip: 'Accept Request',
      onClick: (_, rowData) => {
        // eslint-disable-next-line no-restricted-globals,no-alert
        if (confirm('Accept request?')) {
          const payload = { id: rowData.id };
          props.acceptRequest(payload);
        }
      }
    });

    actions.push({
      icon: () => (<ClearIcon />),
      tooltip: 'Reject Request',
      onClick: (_, rowData) => {
        // eslint-disable-next-line no-restricted-globals,no-alert
        if (confirm('Reject request?')) {
          const payload = { id: rowData.id };
          props.rejectRequest(payload);
        }
      }
    });
  } else
    actions.push({
      icon: () => (<DeleteIcon />),
      tooltip: 'Delete Request',
      onClick: (_, rowData) => {
        // eslint-disable-next-line no-restricted-globals,no-alert
        if (confirm('Delete request?')) {
          const payload = { id: rowData.id };
          props.deleteRequest(payload);
        }
      }
    });

  actions.push({
    icon: () => <PersonIcon />,
    tooltip: 'See Profile',
    onClick: (_, rowData) => {
      handleProfileClickOpen(type === 'incoming' ? rowData.sender : rowData.receiver);
    }
  });

  const handleOrderChange = (columnId, orderDir) => {
    props.handleRequestOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <React.Fragment>
      <Box mb={1} />
      <DiverstTable
        title={`${type.charAt(0).toUpperCase() + type.slice(1)} Request(s)`}
        handlePagination={props.handleRequestPagination}
        onOrderChange={handleOrderChange}
        isLoading={props.isFetchingRequests}
        rowsPerPage={5}
        params={props.params}
        dataArray={props.requests}
        dataTotal={props.requestsTotal}
        columns={columns}
        actions={actions}
        my_options={{
          rowStyle: (rowData) => {
            let colour;
            switch (rowData.status) {
              case 'accepted':
                colour = '#EFE';
                break;
              case 'rejected':
                colour = '#FEE';
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
  );
}

MentorRequestList.propTypes = {
  type: PropTypes.string,
  classes: PropTypes.object,
  user: PropTypes.object,
  requests: PropTypes.array,
  requestsTotal: PropTypes.number,
  isFetchingRequests: PropTypes.bool,
  userParams: PropTypes.object,
  handleRequestPagination: PropTypes.func,
  handleRequestOrdering: PropTypes.func,
  params: PropTypes.object,
  rejectRequest: PropTypes.func,
  acceptRequest: PropTypes.func,
  deleteRequest: PropTypes.func,
  reloadRequest: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles),
)(MentorRequestList);
