/**
 *
 * MetricsDashboards List Component
 *
 */

import React, {memo, useContext, useEffect, useRef, useState} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Paper,
  Card, CardContent, Grid, Link, TablePagination, Typography, Button, Hidden,
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import MaterialTable from 'material-table';
import tableIcons from 'utils/tableIcons';
import buildDataFunction from 'utils/dataTableHelper';
import DeleteOutline from '@material-ui/icons/DeleteOutline';

import { FormattedMessage, injectIntl } from 'react-intl';
import messages from 'containers/Analyze/Dashboards/MetricsDashboard/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import Edit from '@material-ui/icons/Edit';

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

  const columns = [
    { title: 'Name', field: 'name' }
  ];

  /* Store reference to table & use to refresh table when data changes */
  const ref = useRef();
  useEffect(() => ref.current && ref.current.onQueryChange(), [props.metricsDashboards]);

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
      <br />
      <Grid container spacing={3}>
        <Grid item xs>
          <MaterialTable
            tableRef={ref}
            icons={tableIcons}
            title='Custom Dashboards'
            onChangePage={handleChangePage}
            onChangeRowsPerPage={handleChangeRowsPerPage}
            data={buildDataFunction(Object.values(props.metricsDashboards), page, props.metricsDashboardsTotal)}
            columns={columns}
            actions={[{
              icon: () => <Edit />,
              tooltip: 'Edit Member',
              onClick: (_, rowData) => {
                props.handleVisitDashboardEdit(rowData.id);
              } }, {
              icon: () => <DeleteOutline />,
              tooltip: 'Delete Member',
              onClick: (_, rowData) => {
                console.log(rowData);
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete member?'))
                  props.deleteMetricsDashboardBegin(rowData.id);
              }
            }]}
            options={{
              actionsColumnIndex: -1,
              pageSize: rowsPerPage,
            }}
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
