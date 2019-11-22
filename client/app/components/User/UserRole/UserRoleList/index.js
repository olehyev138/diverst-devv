/**
 *
 * UserRoleList Component
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
  Typography, Grid, Link, TablePagination, Collapse, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/User/UserRole/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';

const styles = theme => ({
  userRoleListItem: {
    width: '100%',
  },
  userListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function UserRoleList(props, context) {
  const { classes, links } = props;

  const columns = [
    { title: 'Role Name', field: 'role_name' },
    { title: 'Role Type', field: 'role_type' },
    { title: 'Role Priority', field: 'priority' },
  ];

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='large'
            to={links.userRoleNew}
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='User Roles'
            handlePagination={props.handlePagination}
            handleOrdering={props.handleOrdering}
            isLoading={props.isFetchingUserRoles}
            rowsPerPage={5}
            dataArray={Object.values(props.userRoles)}
            dataTotal={props.userRoleTotal}
            columns={columns}
            actions={[{
              icon: () => <EditIcon />,
              tooltip: 'Edit User Role',
              onClick: (_, rowData) => {
                props.handleVisitUserRoleEdit(rowData.id);
              }
            }, {
              icon: () => <DeleteIcon />,
              tooltip: 'Delete User Role',
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete user role?'))
                  props.deleteUserRoleBegin(rowData.id);
              }
            }]}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

UserRoleList.propTypes = {
  classes: PropTypes.object,
  userRoles: PropTypes.object,
  userRoleTotal: PropTypes.number,
  isFetchingUserRoles: PropTypes.bool,
  deleteUserRoleBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitUserRoleEdit: PropTypes.func,
  links: PropTypes.shape({
    userRoleNew: PropTypes.string,
    userRoleEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(UserRoleList);
