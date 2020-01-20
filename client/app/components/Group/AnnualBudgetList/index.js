/**
 *
 * AnnualBudgetList Component
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

import AddIcon from '@material-ui/icons/Add';
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';


const styles = theme => ({
  annualBudgetListItem: {
    width: '100%',
  },
  annualBudgetListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function AnnualBudgetList(props, context) {
  const { classes } = props;

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: 'Group Name',
      field: 'name',
      query_field: 'group_name'
    },
    {
      title: 'Annual Budget',
      field: 'annual_budget',
      query_field: 'last_name'
    },
    {
      title: 'Leftover Money',
      field: 'annual_budget_leftover',
      query_field: ''
    },
    {
      title: 'Approved Budget',
      field: 'annual_budget_approved',
      query_field: ''
    },
  ];

  const actions = [];

  actions.push({
    icon: () => <EditIcon />,
    tooltip: 'Edit Budget',
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      alert('Not Implemented Yet');
    }
  });

  actions.push({
    icon: () => <DeleteIcon />,
    tooltip: 'Carry Over',
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      alert('Not Implemented Yet');
    }
  });

  actions.push({
    icon: () => <DeleteIcon />,
    tooltip: 'Reset Budget',
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
            title='Members'
            handlePagination={props.handlePagination}
            handleOrdering={props.handleOrdering}
            isLoading={props.isFetchingAnnualBudgets}
            rowsPerPage={5}
            dataArray={Object.values(props.annualBudgets)}
            dataTotal={props.annualBudgetTotal}
            columns={columns}
            actions={actions}
            parentChildData={(row, rows) => rows.find(a => a.id === row.parent_id)}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

AnnualBudgetList.propTypes = {
  classes: PropTypes.object,
  annualBudgets: PropTypes.object,
  annualBudgetTotal: PropTypes.number,
  isFetchingAnnualBudgets: PropTypes.bool,
  deleteAnnualBudgetBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitAnnualBudgetEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  annualBudgetType: PropTypes.string,
  links: PropTypes.shape({
    annualBudgetNew: PropTypes.string,
    annualBudgetEdit: PropTypes.func
  })
};

export default compose(
  memo,
  withStyles(styles),
)(AnnualBudgetList);
