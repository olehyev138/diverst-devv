/**
 *
 * BudgeList Component
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
import {DateTime, formatDateTimeString} from "../../../../utils/dateTimeHelpers";

const styles = theme => ({
  budgeListItem: {
    width: '100%',
  },
  budgeListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function BudgeList(props, context) {
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
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Budgets'
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingBudges}
            rowsPerPage={5}
            dataArray={Object.values(props.budges)}
            dataTotal={props.budgeTotal}
            columns={columns}
            actions={actions}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

BudgeList.propTypes = {
  classes: PropTypes.object,
  budges: PropTypes.object,
  budgeTotal: PropTypes.number,
  isFetchingBudges: PropTypes.bool,
  deleteBudgeBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitBudgeEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  budgeType: PropTypes.string,
  links: PropTypes.shape({
    budgeNew: PropTypes.string,
    budgeEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(BudgeList);
