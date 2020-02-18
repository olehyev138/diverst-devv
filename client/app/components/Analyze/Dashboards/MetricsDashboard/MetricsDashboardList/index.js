/**
 *
 * MetricsDashboards List Component
 *
 */

import React, {
  memo, useContext, useEffect, useRef, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Paper,
  Card, CardContent, Grid, Link, TablePagination, Typography, Button, Hidden,
} from '@material-ui/core';

import AddIcon from '@material-ui/icons/Add';
import EditIcon from '@material-ui/icons/Edit';
import DeleteIcon from '@material-ui/icons/DeleteOutline';

import { injectIntl } from 'react-intl';
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

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

  const routeContext = useContext(RouteContext);

  const columns = [
    { title: 'Name', field: 'name' }
  ];

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
            startIcon={<AddIcon />}
          >
            <DiverstFormattedMessage {...messages.new} />
          </Button>
        </Grid>
      </Grid>
      <Box mb={1} />
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={<DiverstFormattedMessage {...messages.table.title} />}
            handlePagination={props.handlePagination}
            handleRowClick={(_, rowData) => props.handleVisitDashboardPage(rowData.id)}
            dataArray={Object.values(props.metricsDashboards)}
            dataTotal={props.metricsDashboardsTotal}
            columns={columns}
            actions={[{
              icon: () => <EditIcon />,
              tooltip: <DiverstFormattedMessage {...messages.table.edit} />,
              onClick: (_, rowData) => {
                props.handleVisitDashboardEdit(rowData.id);
              }
            }, {
              icon: () => <DeleteIcon />,
              tooltip: <DiverstFormattedMessage {...messages.table.delete} />,
              onClick: (_, rowData) => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete member?'))
                  props.deleteMetricsDashboardBegin(rowData.id);
              }
            }]}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

MetricsDashboardsList.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  metricsDashboards: PropTypes.array,
  metricsDashboardsTotal: PropTypes.number,
  deleteMetricsDashboardBegin: PropTypes.func,
  handleVisitDashboardPage: PropTypes.func,
  handleVisitDashboardEdit: PropTypes.func,
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
