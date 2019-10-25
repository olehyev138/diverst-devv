/**
 *
 * UserList Component
 *
 *
 */

import React, {
  memo, useEffect, useRef, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box, Paper,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';
import AssignmentIndIcon from '@material-ui/icons/AssignmentInd';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstPagination from 'components/Shared/DiverstPagination';


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

export function UserList(props, context) {
  // const { classes } = props;
  // const [expandedUsers, setExpandedUsers] = useState({});
  //
  // const [userForm, setUserForm] = useState(undefined);

  const { type } = props;

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' },
    { title: 'Email', field: 'email' },
    { title: 'Interests', field: 'interests' },
  ];

  return (
    <React.Fragment>
      <DiverstTable
        title={`Your ${type.charAt(0).toUpperCase() + type.slice(1)}`}
        handlePagination={props.handleMentorPagination}
        handleOrdering={props.handleMentorOrdering}
        isLoading={props.isFetchingUsers}
        rowsPerPage={5}
        dataArray={props.users}
        dataTotal={props.userTotal}
        columns={columns}
        actions={[{
          icon: () => <AssignmentIndIcon />,
          tooltip: 'Edit Member',
          onClick: (_, rowData) => {
            // console.log('click 1');
          }
        }, {
          icon: () => <DeleteIcon />,
          tooltip: 'Delete Member',
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            // if (confirm('Delete member?'))
            // console.log('click 2');
          }
        }]}
      />
      <Box mb={2} />
      <DiverstTable
        title={`Available ${type.charAt(0).toUpperCase() + type.slice(1)}`}
        handlePagination={props.handleMentorPagination}
        handleOrdering={props.handleMentorOrdering}
        isLoading={props.isFetchingAvailableUsers}
        rowsPerPage={5}
        dataArray={props.availableUsers}
        dataTotal={props.availableUserTotal}
        columns={columns}
        actions={[{
          icon: () => <AssignmentIndIcon />,
          tooltip: 'Edit Member',
          onClick: (_, rowData) => {
            // console.log('click 1');
          }
        }, {
          icon: () => <DeleteIcon />,
          tooltip: 'Delete Member',
          onClick: (_, rowData) => {
            /* eslint-disable-next-line no-alert, no-restricted-globals */
            // if (confirm('Delete member?'))
            // console.log('click 2');
          }
        }]}
      />
    </React.Fragment>
  );
}

UserList.propTypes = {
  type: PropTypes.string,
  classes: PropTypes.object,
  users: PropTypes.array,
  userTotal: PropTypes.number,
  isFetchingUsers: PropTypes.bool,
  availableUsers: PropTypes.array,
  availableUserTotal: PropTypes.number,
  isFetchingAvailableUsers: PropTypes.bool,
  userParams: PropTypes.object,
  handleMentorPagination: PropTypes.func,
  handleMentorOrdering: PropTypes.func,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(UserList);
