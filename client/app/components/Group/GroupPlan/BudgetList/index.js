/**
 *
 * BudgetList Component
 *
 *
 */

import React, {
  memo
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box, MenuItem,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import DetailsIcon from '@material-ui/icons/Details';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';

const styles = theme => ({
  budgetListItem: {
    width: '100%',
  },
  budgetListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function BudgetList(props, context) {
  const { classes } = props;

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: 'Requested Amount',
      field: 'requested_amount',
      sorting: false,
      render: rowData => rowData.requested_amount || '$0.00',
    },
    {
      title: 'Available Amount',
      field: 'available_amount',
      sorting: false,
      render: rowData => rowData.available_amount || 'Not Set'
    },
    {
      title: 'Status',
      field: 'status',
      sorting: false,
    },
    {
      title: 'Requested At',
      field: 'requested_at',
      query_field: 'created_at',
      render: rowData => formatDateTimeString(rowData.requested_at, DateTime.DATETIME_MED)
    },
    {
      title: '# Of Events',
      field: 'item_count',
      sorting: false,
    },
    {
      title: 'Description',
      field: 'description',
      query_field: 'description',
    },
  ];

  const actions = [];

  actions.push({
    icon: () => <DetailsIcon />,
    tooltip: 'Details',
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      alert('Not Implemented Yet');
    }
  });

  actions.push({
    icon: () => <DeleteIcon />,
    tooltip: 'Delete',
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      alert('Not Implemented Yet');
    }
  });

  return (
    <React.Fragment>
      <CardContent>
        <Grid
          container
          alignContent='flex-end'
          alignItems='flex-end'
          justify='flex-end'
        >
          <Grid item>
            <Button
              color='primary'
              variant={props.annualBudget && !props.annualBudget.closed ? 'contained' : 'disabled' }
              to={props.links.newRequest}
              component={WrappedNavLink}
            >
              New Budget Request
            </Button>
          </Grid>
        </Grid>
      </CardContent>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Budgets'
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingBudgets}
            rowsPerPage={5}
            dataArray={Object.values(props.budgets)}
            dataTotal={props.budgetTotal}
            columns={columns}
            actions={actions}
            editable={{
              onRowAdd: newData => alert('YO YO'),
            }}
            my_options={{
              search: false,
              exportButton: true
            }}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

BudgetList.propTypes = {
  classes: PropTypes.object,
  annualBudget: PropTypes.object,
  currentGroup: PropTypes.object,
  budgets: PropTypes.object,
  budgetTotal: PropTypes.number,
  isFetchingBudgets: PropTypes.bool,
  deleteBudgetBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitBudgetEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  budgetType: PropTypes.string,
  links: PropTypes.shape({
    newRequest: PropTypes.string,
    requestDetails: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(BudgetList);
