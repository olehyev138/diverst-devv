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
  Typography, Grid, Link, TablePagination, Collapse
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/User/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';


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
  const { classes } = props;
  const [expandedUsers, setExpandedUsers] = useState({});

  const [userForm, setUserForm] = useState(undefined);

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' }
  ];

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            color='primary'
            size='large'
            to={props.links.userNew}
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Members'
            isLoading={props.isFetchingUsers}
            rowsPerPage={5}
            dataArray={Object.values(props.users)}
            dataTotal={props.userTotal}
            columns={columns}
            actions={[{
              icon: () => <EditIcon />,
              tooltip: 'Edit Member',
              onClick: (_, rowData) => {
                props.handleVisitUserEdit(rowData.id);
              }
            }, {
              icon: () => <DeleteIcon />,
              tooltip: 'Delete Member',
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete member?'))
                  props.deleteUserBegin(rowData.id);
              }
            }]}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

UserList.propTypes = {
  classes: PropTypes.object,
  users: PropTypes.object,
  userTotal: PropTypes.number,
  isFetchingUsers: PropTypes.bool,
  deleteUserBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitUserEdit: PropTypes.func,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(UserList);
