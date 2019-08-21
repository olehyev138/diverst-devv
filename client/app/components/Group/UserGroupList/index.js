/**
 *
 * UserGroupList
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { NavLink } from 'react-router-dom';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, CardActions, CardActionArea,
  Typography, Grid, Link, TablePagination, Collapse, Box,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import { FormattedMessage } from 'react-intl';
import messages from 'containers/Group/messages';

const styles = theme => ({
  groupListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  groupCard: {
    width: '100%',
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  childGroupCard: {
    marginLeft: 24,
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  expandButton: {
    fontWeight: 600,
    fontSize: 24,
  },
});

export function UserGroupList(props, context) {
  const { classes, defaultParams } = props;
  const [page, setPage] = useState(defaultParams.page);
  const [rowsPerPage, setRowsPerPage] = useState(defaultParams.count);
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
        { /* eslint-disable-next-line arrow-body-style */ }
        {props.groups && Object.values(props.groups).map((group, i) => {
          return (
            <Grid item xs={12} key={group.id}>
              <Card className={classes.groupCard}>
                <Grid container>
                  <Grid item xs>
                    {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                    <Link
                      component={WrappedNavLink}
                      to={{
                        pathname: ROUTES.group.home.path(group.id),
                        state: { id: group.id }
                      }}
                    >
                      <CardActionArea>
                        <CardContent>
                          <Typography variant='h5' component='h2' display='inline'>
                            {group.name}
                          </Typography>
                          {group.description && (
                            <Typography color='textSecondary' className={classes.groupListItemDescription}>
                              {group.description}
                            </Typography>
                          )}
                        </CardContent>
                      </CardActionArea>
                    </Link>
                  </Grid>
                  <Grid item>
                    <CardContent>
                      <Button
                        className={classes.expandButton}
                        variant='outlined'
                        color='primary'
                        onClick={() => {
                          setExpandedGroups({
                            ...expandedGroups,
                            [group.id]: !expandedGroups[group.id]
                          });
                        }}
                      >
                        {expandedGroups[group.id] ? (
                          <FormattedMessage {...messages.children_collapse} />
                        ) : (
                          <FormattedMessage {...messages.children_expand} />
                        )}
                      </Button>
                    </CardContent>
                  </Grid>
                </Grid>
              </Card>
              <Collapse in={expandedGroups[`${group.id}`]}>
                <Box mt={1} />
                <Grid container spacing={2} justify='flex-end'>
                  {group.children && group.children.map((childGroup, i) => (
                    /* eslint-disable-next-line react/jsx-wrap-multilines */
                    <Grid item key={childGroup.id} xs={12}>
                      <Card className={classes.childGroupCard}>
                        <CardContent>
                          {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                          <Link
                            component={WrappedNavLink}
                            to={{
                              pathname: ROUTES.group.home.path(childGroup.id),
                              state: { id: childGroup.id }
                            }}
                          >
                            <Typography variant='h5' component='h2' display='inline'>
                              {childGroup.name}
                            </Typography>
                          </Link>
                          {childGroup.description && (
                            <Typography color='textSecondary' className={classes.groupListItemDescription}>
                              {childGroup.description}
                            </Typography>
                          )}
                        </CardContent>
                      </Card>
                    </Grid>
                  ))}
                </Grid>
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

UserGroupList.propTypes = {
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(UserGroupList);
