/**
 *
 * Group Categories List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupCategories/messages';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  Button, Card, CardContent, Typography, Grid, Box, Collapse,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import AddIcon from '@material-ui/icons/Add';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import { injectIntl, intlShape } from 'react-intl';

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
    borderLeftColor: theme.palette.secondary.main,
    borderTopLeftRadius: 4,
    borderBottomLeftRadius: 4,
  },
});

export function GroupCategoriesList(props, context) {
  const { classes, defaultParams, intl } = props;
  const [expandedSubgroups, setExpandedSubgroups] = useState({});

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
          {props.categoryTypes && Object.values(props.categoryTypes).length > 0 ? Object.values(props.categoryTypes).map((categoryType, i) => (
            <Grid item key={categoryType.id} xs={12}>
              <Card className={classes.groupCard}>
                <CardContent>
                  {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                  <Typography variant='h5' component='h2' display='inline'>
                    {categoryType.name}
                  </Typography>
                  <Button
                    size='small'
                    color='primary'
                    to={{
                      pathname: `${ROUTES.admin.manage.groups.categories.pathPrefix}/${categoryType.id}/edit`,
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
                      if (confirm(intl.formatMessage(messages.delete_confirm, props.customTexts)))
                        props.deleteGroupCategoriesBegin(categoryType.id);
                    }}
                  >
                    <DiverstFormattedMessage {...messages.delete} />
                  </Button>
                </CardContent>
                <CardContent>
                  <Grid container spacing={1} justify='flex-end'>
                    {categoryType.group_categories && categoryType.group_categories.map((category, i) => (
                      /* eslint-disable-next-line react/jsx-wrap-multilines */
                      <Grid item key={category.id} xs={12}>
                        <Card className={classes.childGroupCard}>
                          <CardContent>
                            {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                            <Button
                              size='medium'
                              color='primary'
                              onClick={() => {
                                setExpandedSubgroups({ ...expandedSubgroups, [category.id]: !expandedSubgroups[category.id] });
                              }}
                            >
                              {category.name}
                              (
                              {category.total_groups}
                              )
                            </Button>
                            <Collapse in={expandedSubgroups[`${category.id}`]}>
                              {category.groups && category.groups.map((group, i) => (
                                <Typography color='primary' variant='body2' margin='30' key={group.id}>
                                  &ensp;&ensp;&ensp;&ensp;
                                  {group.name}
                                </Typography>
                              ))}
                            </Collapse>
                          </CardContent>
                        </Card>
                      </Grid>
                    ))}
                  </Grid>
                </CardContent>
              </Card>
            </Grid>
          ))
            : (
              <React.Fragment>
                <Grid item sm>
                  <Box mt={3} />
                  <Typography variant='h6' align='center' color='textSecondary'>
                    <DiverstFormattedMessage {...messages.nocategories} />
                  </Typography>
                </Grid>
              </React.Fragment>
            )
          }
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        handlePagination={props.handlePagination}
        rowsPerPage={defaultParams.count}
        count={props.groupCategoriesTotal}
      />
    </React.Fragment>
  );
}

GroupCategoriesList.propTypes = {
  intl: intlShape.isRequired,
  defaultParams: PropTypes.object,
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  categoryTypes: PropTypes.object,
  groupCategoriesTotal: PropTypes.number,
  deleteGroupCategoriesBegin: PropTypes.func,
  deleteGroupCategoryBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  customTexts: PropTypes.object
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(GroupCategoriesList);
