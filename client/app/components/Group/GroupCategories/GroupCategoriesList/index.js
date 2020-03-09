/**
 *
 * Group Categories List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/messages';

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

export function GroupCategoriesList(props, context) {
  const { classes, defaultParams } = props;
  console.log('component');
  console.log(props);
  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={ROUTES.admin.manage.groups.categories.new.path()}
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
          {props.categoryTypes && Object.values(props.categoryTypes).map((categoryType, i) => {
            return (
              <Grid item key={categoryType.id} xs={12}>
                <Card className={classes.groupCard}>
                  <CardContent>
                    {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                    <Typography variant='h5' component='h2' display='inline'>
                      {categoryType.name}
                    </Typography>
                  </CardContent>
                  <CardActions>
                    <Button
                      size='small'
                      color='primary'
                      to={{
                        pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${categoryType.id}/edit`,
                        state: { id: categoryType.id }
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
                          props.deleteGroupCategoryBegin(categoryType.id);
                      }}
                    >
                      <DiverstFormattedMessage {...messages.delete} />
                    </Button>
                    <Button
                      size='small'
                      color='primary'
                      to={{
                        pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${categoryType.id}/edit`,
                        state: { id: categoryType.id }
                      }}
                      component={WrappedNavLink}
                    >
                      Categorize Subgroups
                    </Button>
                  </CardActions>
                  <Box mt={1} />
                  <Grid container spacing={2} justify='flex-end'>
                    {categoryType.group_categories && categoryType.group_categories.map((category, i) => (
                      /* eslint-disable-next-line react/jsx-wrap-multilines */
                      <Grid item key={category.id} xs={12}>
                        <Card className={classes.childGroupCard}>
                          <CardContent>
                            {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                            <Link
                              component={WrappedNavLink}
                              to={{
                                pathname: ROUTES.group.home.path(category.id),
                                state: { id: category.id }
                              }}
                            >
                              <Typography variant='h5' component='h2' display='inline'>
                                {category.name}
                              </Typography>
                            </Link>
                          </CardContent>
                          <CardActions>
                            <Button
                              size='small'
                              color='primary'
                              to={{
                                pathname: `${ROUTES.admin.manage.groups.pathPrefix}/${category.id}/edit`,
                                state: { id: category.id }
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
                                  props.deleteGroupCategoryBegin(category.id);
                              }}
                            >
                              <DiverstFormattedMessage {...messages.delete} />
                            </Button>
                          </CardActions>
                        </Card>
                      </Grid>
                    ))}
                  </Grid>
                </Card>
              </Grid>
            );
          })}
        </Grid>
      </DiverstLoader>
    </React.Fragment>
  );
}

GroupCategoriesList.propTypes = {
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  categoryTypes: PropTypes.object,
  deleteGroupCategoryBegin: PropTypes.func,
  handlePagination: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(GroupCategoriesList);
