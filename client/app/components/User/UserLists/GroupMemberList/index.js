/**
 *
 * Group Member List Component
 *
 */

import React, {
  memo, useState, useContext
} from 'react';
import { NavLink } from 'react-router-dom';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';

import {
  Button, Card, CardActions, CardContent, Grid,
  TablePagination
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { ROUTES } from 'containers/Shared/Routes/constants';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/User/UserLists/messages';

const styles = theme => ({
});

export function NewsFeed(props) {
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
      </Grid>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={[5, 10, 25]}
        rowsPerPage={rowsPerPage}
        count={ 0 }
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

NewsFeed.propTypes = {
  classes: PropTypes.object,
  // handlePagination: PropTypes.func,
  links: PropTypes.shape({
  })
};

export default compose(
  memo,
  withStyles(styles)
)(NewsFeed);
