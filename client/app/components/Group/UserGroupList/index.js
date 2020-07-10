/**
 *
 * UserGroupList
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Card, CardContent, CardActionArea,
  Typography, Grid, Link, Collapse, Box, Hidden,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import JoinedGroupIcon from '@material-ui/icons/CheckCircle';
import AddIcon from '@material-ui/icons/Add';
import RemoveIcon from '@material-ui/icons/Remove';

import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstPagination from 'components/Shared/DiverstPagination';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstImg from 'components/Shared/DiverstImg';

const styles = theme => ({
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
  groupCardContent: {
    paddingTop: 20,
    paddingBottom: 20,
  },
  groupCardTitle: {
    verticalAlign: 'middle',
  },
  groupCardIcon: {
    verticalAlign: 'middle',
    marginRight: 6,
  },
  groupCardDescription: {
    paddingTop: 8,
  },
  groupCardLink: {
    textDecoration: 'none !important',
  },
  childGroupCard: {
    marginLeft: 24,
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  expandActionAreaContainer: {
    borderLeftWidth: 1,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.custom.colors.lightGrey,
  },
  expandActionArea: {
    padding: '4px 12px',
    height: '100%',
  },
  expandIcon: {
    fontSize: 34,
  },
});

export function UserGroupList(props, context) {
  const { classes, defaultParams } = props;
  const [expandedGroups, setExpandedGroups] = useState({});

  /* Store a expandedGroupsHash for each group, that tracks whether or not its children are expanded */
  if (props.groups && Object.keys(props.groups).length !== 0 && Object.keys(expandedGroups).length <= 0) {
    const initialExpandedGroups = {};

    /* Setup initial hash, with each group set to false - do it like this because of how React works with state */
    /* eslint-disable-next-line no-return-assign */
    Object.keys(props.groups).map((id, i) => initialExpandedGroups[id] = false);
    setExpandedGroups(initialExpandedGroups);
  }

  return (
    <React.Fragment>
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.groups && Object.values(props.groups).map((group, i) => (
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
                      className={classes.groupCardLink}
                    >
                      <CardActionArea>
                        <CardContent className={classes.groupCardContent}>
                          <Grid container spacing={2} alignItems='center'>
                            {group.logo_data && (
                              <React.Fragment>
                                <Hidden xsDown>
                                  <Grid item xs='auto'>
                                    <DiverstImg
                                      data={group.logo_data}
                                      contentType={group.logo_content_type}
                                      maxWidth='70px'
                                      maxHeight='70px'
                                      minWidth='70px'
                                      minHeight='70px'
                                    />
                                  </Grid>
                                </Hidden>
                              </React.Fragment>
                            )}
                            <Grid item xs>
                              {group.current_user_is_member === true && (
                                <JoinedGroupIcon className={classes.groupCardIcon} />
                              )}
                              <Typography variant='h5' component='h2' display='inline' className={classes.groupCardTitle}>
                                {group.name}
                              </Typography>
                              {group.short_description && (
                                <Typography color='textSecondary' className={classes.groupCardDescription}>
                                  {group.short_description}
                                </Typography>
                              )}
                            </Grid>
                          </Grid>
                        </CardContent>
                      </CardActionArea>
                    </Link>
                  </Grid>
                  {group.children && group.children.length > 0 && (
                    <Grid item className={classes.expandActionAreaContainer}>
                      <CardActionArea
                        className={classes.expandActionArea}
                        onClick={() => {
                          setExpandedGroups({
                            ...expandedGroups,
                            [group.id]: !expandedGroups[group.id]
                          });
                        }}
                      >
                        {expandedGroups[group.id] ? (
                          <RemoveIcon color='primary' className={classes.expandIcon} />
                        ) : (
                          <AddIcon color='primary' className={classes.expandIcon} />
                        )}
                      </CardActionArea>
                    </Grid>
                  )}
                </Grid>
              </Card>
              <Collapse in={expandedGroups[`${group.id}`]}>
                <Box mt={1} />
                <Grid container spacing={2} justify='flex-end'>
                  {group.children && group.children.map((childGroup, i) => (
                    /* eslint-disable-next-line react/jsx-wrap-multilines */
                    <Grid item key={childGroup.id} xs={12}>
                      <Card className={classes.childGroupCard}>
                        {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                        <Link
                          component={WrappedNavLink}
                          to={{
                            pathname: ROUTES.group.home.path(childGroup.id),
                            state: { id: childGroup.id }
                          }}
                          className={classes.groupCardLink}
                        >
                          <CardActionArea>
                            <CardContent className={classes.groupCardContent}>
                              <Grid container spacing={2} alignItems='center'>
                                {childGroup.logo_data && (
                                  <React.Fragment>
                                    <Hidden xsDown>
                                      <Grid item xs='auto'>
                                        <DiverstImg
                                          data={childGroup.logo_data}
                                          contentType={childGroup.logo_content_type}
                                          maxWidth='60px'
                                          maxHeight='60px'
                                          minWidth='60px'
                                          minHeight='60px'
                                        />
                                      </Grid>
                                    </Hidden>
                                  </React.Fragment>
                                )}
                                <Grid item xs>
                                  {childGroup.current_user_is_member === true && (
                                    <JoinedGroupIcon className={classes.groupCardIcon} />
                                  )}
                                  <Typography variant='h5' component='h2' display='inline'>
                                    {childGroup.name}
                                  </Typography>
                                  {childGroup.short_description && (
                                    <Typography color='textSecondary' className={classes.groupCardDescription}>
                                      {childGroup.short_description}
                                    </Typography>
                                  )}
                                </Grid>
                              </Grid>
                            </CardContent>
                          </CardActionArea>
                        </Link>
                      </Card>
                    </Grid>
                  ))}
                </Grid>
              </Collapse>
            </Grid>
          ))}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        rowsPerPage={defaultParams.count}
        count={props.groupTotal}
        handlePagination={props.handlePagination}
        page={defaultParams.page}
      />
    </React.Fragment>
  );
}

UserGroupList.propTypes = {
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  groups: PropTypes.array,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  viewChildren: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles),
)(UserGroupList);
