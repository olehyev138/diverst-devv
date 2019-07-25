/**
 *
 * Group Member List Component
 *
 */

import React, {
  forwardRef, memo, useState, useContext
} from 'react';
import { compose } from 'redux';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

import {
  Button, Card, CardActions, CardContent, Grid,
  TablePagination
} from '@material-ui/core/index';
import { withStyles } from '@material-ui/core/styles';
import MaterialTable from 'material-table';
import tableIcons from 'utils/tableIcons';

import { ROUTES } from 'containers/Shared/Routes/constants';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/GroupMembers/messages';

const styles = theme => ({
});

export function GroupMemberList(props) {
  const { classes } = props;
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    // props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    // props.handlePagination({ count: +event.target.value, page });
  };

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to='#'
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            New Group Message
          </Button>
        </Grid>
        <Grid item>
          <Button
            variant='contained'
            to='#'
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            Export Group Members
          </Button>
        </Grid>
        <Grid item xs={12}>
          <MaterialTable
            icons={tableIcons}
            columns={[
              { title: 'First Name', field: 'first_name' },
              { title: 'Last Name', field: 'last_name' }
            ]}
            data={query =>
              new Promise((resolve, reject) => {
                resolve({
                  data: [{ first_name: 'name', last_name: 'lastname' }],
                  page: 0,
                  totalCount: 9
                });
              })
            }
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

GroupMemberList.propTypes = {
  classes: PropTypes.object,
  // handlePagination: PropTypes.func,
  links: PropTypes.shape({
  })
};

export default compose(
  memo,
  withStyles(styles)
)(GroupMemberList);
