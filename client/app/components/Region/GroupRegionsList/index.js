/**
 *
 * Group Regions List Component
 *
 */

import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { withStyles } from '@material-ui/core/styles';
import { intlShape } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Region/messages';

import {
  Button, Card, Grid, Divider, Box, Typography,
} from '@material-ui/core';
import AddIcon from '@material-ui/icons/Add';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstPagination from 'components/Shared/DiverstPagination';

import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

import GroupRegionsListItem from 'components/Region/GroupRegionsListItem';

const styles = theme => ({
  pageTitle: {
    fontWeight: 'bold',
  },
  groupName: {
    color: theme.palette.primary.main,
  },
  emptyText: {
    fontSize: '1.25rem',
  },
});

export function GroupRegionsList(props) {
  const { classes, group, regions, isLoading, isRegionsLoading, deleteRegionBegin, intl } = props;

  return (
    <React.Fragment>
      <DiverstShowLoader isLoading={isLoading} isError={!isLoading && !group}>
        {group && (
          <React.Fragment>
            <Grid container spacing={3} justify='space-between'>
              <Grid item>
                <Typography color='textSecondary' variant='h5' className={classes.pageTitle}>
                  <Box component='span' className={classes.groupName}>
                    {group.name}
                  </Box>
                  &nbsp;
                  <DiverstFormattedMessage {...messages.regions} />
                </Typography>
              </Grid>
              <Grid item>
                <Permission show={permission(props, 'groups_create')}>
                  <Button
                    variant='contained'
                    to={ROUTES.admin.manage.groups.regions.new.path(group.id)}
                    color='primary'
                    size='large'
                    startIcon={<AddIcon />}
                    component={WrappedNavLink}
                  >
                    <DiverstFormattedMessage {...messages.new} />
                  </Button>
                </Permission>
              </Grid>
            </Grid>
            <Box mb={3} />
            <DiverstLoader isLoading={isRegionsLoading}>
              <Card>
                <Grid container>
                  {regions && regions.map((region, i) => (
                    <Grid item key={region.id} xs={12}>
                      <GroupRegionsListItem
                        region={region}
                        group={group}
                        deleteRegionBegin={deleteRegionBegin}
                        customTexts={props.customTexts}
                        intl={intl}
                      />
                      {i < regions.length - 1 && (
                        <Divider />
                      )}
                    </Grid>
                  ))}
                  {regions && regions.length <= 0 && (
                    <Grid item xs={12} align='center'>
                      <Box pt={3} pb={3} pl={1} pr={1}>
                        <Typography color='textSecondary' className={classes.emptyText}>
                          <DiverstFormattedMessage {...messages.empty} />
                        </Typography>
                      </Box>
                    </Grid>
                  )}
                </Grid>
              </Card>
            </DiverstLoader>

            {regions && regions.length > 0 && (
              <DiverstPagination
                isLoading={props.isRegionsLoading}
                count={props.regionTotal}
                page={props.params.page}
                rowsPerPage={props.params.count}
                handlePagination={props.handlePagination}
              />
            )}
          </React.Fragment>
        )}
      </DiverstShowLoader>
    </React.Fragment>
  );
}

GroupRegionsList.propTypes = {
  classes: PropTypes.object,
  group: PropTypes.object,
  regions: PropTypes.array,
  regionTotal: PropTypes.number,
  deleteRegionBegin: PropTypes.func,
  isLoading: PropTypes.bool,
  isRegionsLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  params: PropTypes.object,
  permissions: PropTypes.object,
  customTexts: PropTypes.object,
  intl: intlShape.isRequired,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupRegionsList);
