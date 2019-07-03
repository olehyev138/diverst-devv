/**
 *
 * Admin AdminGroupList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { NavLink } from 'react-router-dom';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  groupListItem: {
    width: '100%',
  },
  groupListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function AdminGroupList(props) {
  const { classes } = props;
  const WrappedNavLink = React.forwardRef((props, ref) => <NavLink innerRef={ref} {...props} />);

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

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
            to={ROUTES.admin.manage.groups.new.path}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            Create
          </Button>
        </Grid>
        {props.groups && Object.values(props.groups).map((group, i) => (
          <Grid item key={group.id} className={classes.groupListItem}>
            <Card>
              <CardContent>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Link href='#'>
                  <Typography variant='h5' component='h2' display='inline'>
                    {group.name}
                  </Typography>
                </Link>
                {group.description && (
                  <Typography color='textSecondary' className={classes.groupListItemDescription}>
                    {group.description}
                  </Typography>
                )}
              </CardContent>
              <CardActions>
                <Button
                  size='small'
                  to={{
                    pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/edit`,
                    state: { id: group.id }
                  }}
                  component={WrappedNavLink}
                >
                  Edit
                </Button>
                <Button
                  size='small'
                  className={classes.errorButton}
                  onClick={() => {
                    /* eslint-disable no-alert, no-restricted-globals */
                    if (confirm('Delete group?'))
                      props.deleteGroupBegin(group.id);
                  }}
                >
                  Delete
                </Button>
              </CardActions>
            </Card>
          </Grid>
        ))}
      </Grid>
      <TablePagination
        component='div'
        page={page}
        rowsPerPageOptions={[5, 10, 25]}
        rowsPerPage={rowsPerPage}
        count={props.groupTotal || 0}
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

AdminGroupList.propTypes = {
  classes: PropTypes.object,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(AdminGroupList);
