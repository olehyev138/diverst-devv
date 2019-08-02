/**
 *
 * UserList Component
 *
 *
 */

import React, { memo, useContext, useState } from 'react';
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

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({ count: +event.target.value, page });
  };

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
        {userForm && <Grid item xs={12}>{userForm}</Grid>}
        { /* eslint-disable-next-line arrow-body-style */ }
        {props.users && Object.values(props.users).map((user, i) => {
          return (
            <Grid item key={user.id} className={classes.userListItem}>
              <Card>
                <CardContent>
                  <p>{`${user.first_name} ${user.last_name}`}</p>
                </CardContent>
                <CardActions>
                  <Button
                    size='small'
                    to={props.links.userEdit(user.id)}
                    component={WrappedNavLink}
                  >
                    <FormattedMessage {...messages.edit} />
                  </Button>
                  <Button
                    size='small'
                    className={classes.errorButton}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm('Delete user?'))
                        props.deleteUserBegin(user.id);
                    }}
                  >
                    <FormattedMessage {...messages.delete} />
                  </Button>
                </CardActions>
              </Card>
            </Grid>
          );
        })}
      </Grid>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={[5, 10, 25]}
        rowsPerPage={rowsPerPage}
        count={props.userTotal || 0}
        onChangePage={handleChangePage}
        onChangeRowsPerPage={handleChangeRowsPerPage}
        backIconButtonProps={{
          'aria-label': 'Previous Page',
        }}
        nextIconButtonProps={{
          'aria-label': 'Next Page',
        }}
      />
    </React.Fragment>
  );
}

UserList.propTypes = {
  classes: PropTypes.object,
  users: PropTypes.object,
  userTotal: PropTypes.number,
  deleteUserBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.shape({
    userNew: PropTypes.string,
    userEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(UserList);
