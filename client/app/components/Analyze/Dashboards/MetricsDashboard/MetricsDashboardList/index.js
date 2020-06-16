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

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { permission } from 'utils/permissionsHelpers';

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
    { title: intl.formatMessage(messages.fields.name), field: 'name' }
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
            title={intl.formatMessage(messages.table.title)}
            handlePagination={props.handlePagination}
            handleRowClick={(_, rowData) => props.handleVisitDashboardPage(rowData.id)}
            dataArray={Object.values(props.metricsDashboards)}
            dataTotal={props.metricsDashboardsTotal}
            columns={columns}
            actions={[
              rowData => ({
                icon: () => <EditIcon />,
                tooltip: intl.formatMessage(messages.table.edit),
                onClick: (_, rowData) => {
                  props.handleVisitDashboardEdit(rowData.id);
                },
                disabled: !permission(rowData, 'update?')
              }),
              rowData => ({
                icon: () => <DeleteIcon />,
                tooltip: intl.formatMessage(messages.table.delete),
                onClick: (_, rowData) => {
                  /* eslint-disable-next-line no-alert, no-restricted-globals */
                  if (confirm(intl.formatMessage(messages.table.delete_confirm)))
                    props.deleteMetricsDashboardBegin(rowData.id);
                },
                disabled: !permission(rowData, 'destroy?')
              })
            ]}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

MetricsDashboardsList.propTypes = {
  intl: intlShape.isRequired,
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
