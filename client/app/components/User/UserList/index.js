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

import { NavLink } from 'react-router-dom';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/User/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import MaterialTable from 'material-table';
import tableIcons from 'utils/tableIcons';
import buildDataFunction from 'utils/dataTableHelper';
import DeleteOutline from '@material-ui/icons/DeleteOutline';
import Edit from '@material-ui/icons/Edit';


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
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);
  const [expandedUsers, setExpandedUsers] = useState({});

  const [userForm, setUserForm] = useState(undefined);

  /* MaterialTable pagination handlers (defined differently then MaterialUI pagination) */
  const handleChangePage = (newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (pageSize) => {
    setRowsPerPage(+pageSize);
    props.handlePagination({ count: +pageSize, page });
  };

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : columns[columnId].field,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    { title: 'First Name', field: 'first_name' },
    { title: 'Last Name', field: 'last_name' }
  ];

  /* Store reference to table & use to refresh table when data changes */
  const ref = useRef();
  useEffect(() => ref.current && ref.current.onQueryChange(), [props.users]);

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
          <MaterialTable
            tableRef={ref}
            icons={tableIcons}
            title='Members'
            onChangePage={handleChangePage}
            onChangeRowsPerPage={handleChangeRowsPerPage}
            onOrderChange={handleOrderChange}
            data={buildDataFunction(Object.values(props.users), page, props.userTotal)}
            columns={columns}
            actions={[{
              icon: () => <Edit />,
              tooltip: 'Edit Member',
              onClick: (_, rowData) => {
                // TODO
              } }, {
              icon: () => <DeleteOutline />,
              tooltip: 'Delete Member',
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete member?'))
                  props.deleteUserBegin(rowData.id);
              }
            }]}
            options={{
              actionsColumnIndex: -1,
              pageSize: rowsPerPage,
            }}
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
  deleteUserBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(UserList);
