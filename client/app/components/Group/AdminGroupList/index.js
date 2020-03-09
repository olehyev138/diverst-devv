/**
 *
 * AdminGroupList List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';
import { injectIntl, intlShape } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, Collapse, Box, CircularProgress,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';

const styles = theme => ({
  progress: {
    margin: theme.spacing(8),
  },
  groupListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  groupCard: {
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.primary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
  groupLink: {
    textTransform: 'none',
  },
  childGroupCard: {
    marginLeft: 24,
    borderLeftWidth: 2,
    borderLeftStyle: 'solid',
    borderLeftColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
});

export function AdminGroupList(props, context) {
  const { classes, defaultParams, intl } = props;
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
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.new.path()}
            color='primary'
            size='large'
            component={WrappedNavLink}
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={1} />
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */ }
          {props.groups && Object.values(props.groups).map((group, i) => {
            return (
              <Grid item key={group.id} xs={12}>
                <Card className={classes.groupCard}>
                  <CardContent>
                    {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                    <Button
                      className={classes.groupLink}
                      color='primary'
                      component={WrappedNavLink}
                      to={{
                        pathname: ROUTES.group.home.path(group.id),
                        state: { id: group.id }
                      }}
                    >
                      <Typography variant='h5' component='h2' display='inline'>
                        {group.name}
                      </Typography>
                    </Button>
                    {group.description && (
                      <Typography color='textSecondary' className={classes.groupListItemDescription}>
                        {group.description}
                      </Typography>
                    )}
                  </CardContent>
                  <CardActions>
                    <Button
                      size='small'
                      color='primary'
                      to={{
                        pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${group.id}/edit`,
                        state: { id: group.id }
                      }}
                      component={WrappedNavLink}
                    >
                      <DiverstFormattedMessage {...messages.edit} />
                    </Button>
                    <Button
                      size='small'
                      className={classes.errorButton}
                      onClick={() => {
                        /* eslint-disable-next-line no-alert, no-restricted-globals */
                        if (confirm(intl.formatMessage(messages.delete_confirm)))
                          props.deleteGroupBegin(group.id);
                      }}
                    >
                      <DiverstFormattedMessage {...messages.delete} />
                    </Button>
                    <Button
                      size='small'
                      onClick={() => {
                        setExpandedGroups({ ...expandedGroups, [group.id]: !expandedGroups[group.id] });
                      }}
                    >
                      {expandedGroups[group.id] ? (
                        <DiverstFormattedMessage {...messages.children_collapse} />
                      ) : (
                        <DiverstFormattedMessage {...messages.children_expand} />
                      )}
                    </Button>
                  </CardActions>
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
                          <CardActions>
                            <Button
                              size='small'
                              color='primary'
                              to={{
                                pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${childGroup.id}/edit`,
                                state: { id: childGroup.id }
                              }}
                              component={WrappedNavLink}
                            >
                              <DiverstFormattedMessage {...messages.edit} />
                            </Button>
                            <Button
                              size='small'
                              className={classes.errorButton}
                              onClick={() => {
                                /* eslint-disable-next-line no-alert, no-restricted-globals */
                                if (confirm('Delete group?'))
                                  props.deleteGroupBegin(childGroup.id);
                              }}
                            >
                              <DiverstFormattedMessage {...messages.delete} />
                            </Button>
                          </CardActions>
                        </Card>
                      </Grid>
                    ))}
                  </Grid>
                </Collapse>
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        handlePagination={props.handlePagination}
        rowsPerPage={defaultParams.count}
        count={props.groupTotal}
      />
    </React.Fragment>
  );
}

AdminGroupList.propTypes = {
  intl: intlShape,
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(AdminGroupList);
