/**
 *
 * MetricsDashboards List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Tab, Paper,
  Card, CardContent, Grid, Link, TablePagination, Typography, Button, Hidden,
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import { FormattedMessage, injectIntl } from 'react-intl';
import messages from 'containers/MetricsDashboard/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

const styles = theme => ({
  metricsDashboardListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  metricsDashboardLink: {
    '&:hover': {
      textDecoration: 'none',
    },
    '&:hover h2': {
      textDecoration: 'underline',
    },
  },
  dateText: {
    fontWeight: 'bold',
  }
});

export function MetricsDashboardsList(props, context) {
  const { classes, intl } = props;

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  const routeContext = useContext(RouteContext);

  const handleChangePage = (metricsDashboard, newPage) => {
    setPage(newPage);
    props.handlePagination({ count: rowsPerPage, page: newPage });
  };

  const handleChangeRowsPerPage = (metricsDashboard) => {
    setRowsPerPage(+metricsDashboard.target.value);
    props.handlePagination({ count: +metricsDashboard.target.value, page });
  };

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='flex-end'>
        <Grid item>
          <Button
            variant='contained'
            to={props.links.metricsDashboardNew}
            color='primary'
            size='large'
            component={WrappedNavLink}
          >
            <FormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={2} />
      <Paper>
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label={intl.formatMessage(messages.index.upcoming)} />
          <Tab label={intl.formatMessage(messages.index.ongoing)} />
          <Tab label={intl.formatMessage(messages.index.past)} />
        </ResponsiveTabs>
      </Paper>
      <br />
      <Grid container spacing={3}>
        { /* eslint-disable-next-line arrow-body-style */}
        {props.metricsDashboards && Object.values(props.metricsDashboards).map((item, i) => {
          return (
            <Grid item key={item.id} className={classes.metricsDashboardListItem}>
              {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
              <Link
                className={classes.metricsDashboardLink}
                component={WrappedNavLink}
                to={{
                  pathname: ROUTES.group.metricsDashboards.show.path(item.owner_group_id, item.id),
                  state: { id: item.id }
                }}
              >
                <Card>
                  <CardContent>
                    <Grid container spacing={1} justify='space-between' alignItems='center'>
                      <Grid item xs>
                        <Typography color='primary' variant='h6' component='h2'>
                          {item.name}
                        </Typography>
                        <hr className={classes.divider} />
                        {item.description && (
                          <React.Fragment>
                            <Typography color='textSecondary'>
                              {item.description}
                            </Typography>
                            <Box pb={1} />
                          </React.Fragment>
                        )}
                        <Box pt={1} />
                        <Typography color='textSecondary' variant='subtitle2' className={classes.dateText}>
                          { /* TODO: Use a clientside date library for this */ }
                          {item.start.substring(0, 10).replace(/-/g, '/')}
                        </Typography>
                      </Grid>
                      <Hidden xsDown>
                        <Grid item>
                          <KeyboardArrowRightIcon className={classes.arrowRight} />
                        </Grid>
                      </Hidden>
                    </Grid>
                  </CardContent>
                </Card>
              </Link>
            </Grid>
          );
        })}
        {props.metricsDashboards && props.metricsDashboards.length <= 0 && (
          <React.Fragment>
            <Grid item sm>
              <Box mt={3} />
              <Typography variant='h6' align='center' color='textSecondary'>
                <FormattedMessage {...messages.index.emptySection} />
              </Typography>
            </Grid>
          </React.Fragment>
        )}
      </Grid>
      {props.metricsDashboards && props.metricsDashboards.length > 0 && (
        <TablePagination
          component='div'
          page={page}
          rowsPerPageOptions={[5, 10, 25]}
          rowsPerPage={rowsPerPage}
          count={props.metricsDashboardsTotal || 0}
          onChangePage={handleChangePage}
          onChangeRowsPerPage={handleChangeRowsPerPage}
          backIconButtonProps={{
            'aria-label': 'Previous Page',
          }}
          nextIconButtonProps={{
            'aria-label': 'Next Page',
          }}
        />
      )}
    </React.Fragment>
  );
}

MetricsDashboardsList.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  metricsDashboards: PropTypes.array,
  metricsDashboardsTotal: PropTypes.number,
  currentTab: PropTypes.number,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(MetricsDashboardsList);
