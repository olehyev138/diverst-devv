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
  Typography, Grid, Link, TablePagination, Collapse
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/messages';

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

export function AdminGroupList(props, context) {
  const { classes } = props;
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);
  const [expandedGroups, setExpandedGroups] = useState({});

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(+event.target.value);
    props.handlePagination({ count: +event.target.value, page });
  };

  /* Store a expandedGroupsHash for each group, that tracks whether or not its children are expanded */
  if (props.groups && Object.keys(props.groups).length !== 0 && Object.keys(expandedGroups).length <= 0) {
    const initialExpandedGroups = {};

    /* eslint-disable-next-line no-return-assign */
    /* Setup initial hash, with each group set to false - do it like this because of how React works with state */
    Object.keys(props.groups).map((id, i) => initialExpandedGroups[id] = false);
    setExpandedGroups(initialExpandedGroups);
  }

  return (
    <React.Fragment>
      <Grid container spacing={3}>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.new.path()}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
        { /* eslint-disable-next-line arrow-body-style */ }
        {props.groups && Object.values(props.groups).map((group, i) => {
          return (
            <Grid item key={group.id} className={classes.groupListItem}>
              <Card>
                <CardContent>
                  {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                  <Link
                    component={WrappedNavLink}
                    to={{
                      pathname: `${ROUTES.group.pathPrefix}/${group.id}`,
                      state: { id: group.id }
                    }}
                  >
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
                    <FormattedMessage {...messages.edit} />
                  </Button>
                  <Button
                    size='small'
                    className={classes.errorButton}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm('Delete group?'))
                        props.deleteGroupBegin(group.id);
                    }}
                  >
                    <FormattedMessage {...messages.delete} />
                  </Button>
                  <Button
                    size='small'
                    onClick={() => {
                      setExpandedGroups({ ...expandedGroups, [group.id]: !expandedGroups[group.id] });
                    }}
                  >
                    <FormattedMessage {...messages.children_collapse} />
                  </Button>
                </CardActions>
              </Card>
              <Collapse in={expandedGroups[`${group.id}`]}>
                {group.children && group.children.map((group, i) => (
                  /* eslint-disable-next-line react/jsx-wrap-multilines */
                  <Card key={group.id}>
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
                  </Card>))
                }
              </Collapse>
            </Grid>
          );
        })}
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