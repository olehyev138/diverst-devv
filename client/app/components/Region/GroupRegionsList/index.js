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

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import messages from 'containers/Region/messages';

import {
  Button, Card, CardContent, Grid, Divider, Box, Typography,
} from '@material-ui/core';
import AddIcon from '@material-ui/icons/Add';

import DiverstShowLoader from 'components/Shared/DiverstShowLoader';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstPagination from 'components/Shared/DiverstPagination';

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
  const { classes, group, regions, isLoading, isRegionsLoading } = props;

  return (
    <React.Fragment>
      <DiverstShowLoader isLoading={isLoading} isError={!isLoading && !group}>
        {group && (
          <React.Fragment>
            <Grid container spacing={3} justify='space-between'>
              <Grid item>
                <Typography color='secondary' variant='h5' className={classes.pageTitle}>
                  <Box component='span' className={classes.groupName}>
                    {group.name}
                  </Box>
                  &nbsp;
                  <DiverstFormattedMessage {...messages.regions} />
                </Typography>
              </Grid>
              <Grid item>
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
              </Grid>
            </Grid>
            <Box mb={3} />
            <DiverstLoader isLoading={isRegionsLoading}>
              <Card>
                <Grid container>
                  {regions && regions.map((region, i) => (
                    <Grid item key={region.id} xs={12}>
                      <CardContent>
                        <Box pt={2} pb={2}>
                          <Typography color='primary' variant='h6'>
                            {region.name}
                          </Typography>
                        </Box>
                      </CardContent>
                      {i < regions.length - 1 && (
                        <Divider />
                      )}
                    </Grid>
                  ))}
                  {regions && regions.length <= 0 && (
                    <Grid item xs={12} align='center'>
                      <Box pt={3} pb={3} pl={1} pr={1}>
                        <Typography color='secondary' className={classes.emptyText}>
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
  isLoading: PropTypes.bool,
  isRegionsLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  params: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(GroupRegionsList);
