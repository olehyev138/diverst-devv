/**
 *
 * ExpenseList Component
 *
 *
 */

import React, {
  memo
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import {floatRound, percent} from 'utils/floatRound';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box, MenuItem, LinearProgress,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import EditIcon from '@material-ui/icons/Edit';

import DiverstTable from 'components/Shared/DiverstTable';
import DiverstDropdownMenu from 'components/Shared/DiverstDropdownMenu';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/News/messages';

const styles = theme => ({
  expenseListItem: {
    width: '100%',
  },
  expenseListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

const BorderLinearProgress = withStyles({
  root: {
    height: 7,
    backgroundColor: '#eee',
    borderRadius: 1000,
  },
  bar: {
    borderRadius: 1000,
  }
})(LinearProgress);

const RoundedBox = withStyles({
  root: {
    borderRadius: 1000,
  },
})(Box);

export function ExpenseList(props, context) {
  const { classes } = props;

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: 'Description',
      field: 'description',
      query_field: 'description',
    },
    {
      title: 'Amount',
      field: 'amount',
      query_field: 'amount',
      render: rowData => rowData.amount ? `$${floatRound(rowData.amount, 2)}` : '$0.00',
    },
    {
      title: 'Date',
      field: 'created_at',
      query_field: 'created_at',
      render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATE_MED)
    },
  ];

  const actions = [];

  actions.push({
    icon: () => <EditIcon />,
    tooltip: 'Details',
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      alert('Not Implemented');
    }
  });

  actions.push({
    icon: () => <DeleteIcon />,
    tooltip: 'Delete',
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      alert('Not Implemented');
    }
  });

  return (
    <React.Fragment>
      <CardContent>
        <Grid
          container
          alignContent='space-between'
          spacing={2}
          alignItems='flex-end'
          justify='flex-end'
        >
          <Grid item xs align='right'>
            <Button
              color='primary'
              variant={props.initiative && !props.initiative.closed ? 'contained' : 'disabled'}
              to={props.links.newExpense}
              component={WrappedNavLink}
            >
              New Expense
            </Button>
          </Grid>
        </Grid>
      </CardContent>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title='Expenses'
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingExpenses}
            rowsPerPage={5}
            dataArray={Object.values(props.expenses)}
            dataTotal={props.expenseTotal}
            columns={columns}
            actions={actions}
            my_options={{
              search: false,
            }}
          />
        </Grid>
      </Grid>
      <Box mb={2} />
      <Card>
        <CardContent>
          <Grid
            alignItems='center'
            justify='center'
            container
            spacing={1}
          >
            <Grid item xs={1}>
              <Typography color='primary' variant='body1' component='h2'>
                Total Expenses
              </Typography>
              <Typography color='secondary' variant='body2' component='h2'>
                {`$${floatRound(props.expenseSumTotal, 2)}`}
              </Typography>
            </Grid>
            <Grid item xs={10}>
              <RoundedBox boxShadow={1}>
                <BorderLinearProgress
                  variant='determinate'
                  value={percent(props.expenseSumTotal, props.initiative.estimated_funding)}
                />
              </RoundedBox>
            </Grid>
            <Grid item xs={1}>
              <Typography color='primary' variant='body1' component='h2' align='right'>
                Estimated Funding
              </Typography>
              <Typography color='secondary' variant='body2' component='h2' align='right'>
                {`$${floatRound(props.initiative.estimated_funding, 2)}`}
              </Typography>
            </Grid>
          </Grid>
        </CardContent>
      </Card>
    </React.Fragment>
  );
}

ExpenseList.propTypes = {
  classes: PropTypes.object,
  initiative: PropTypes.object,
  currentGroup: PropTypes.object,
  expenses: PropTypes.array,
  expenseTotal: PropTypes.number,
  expenseSumTotal: PropTypes.number,
  isFetchingExpenses: PropTypes.bool,
  deleteExpenseBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitExpenseEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  expenseType: PropTypes.string,
  handleVisitExpenseShow: PropTypes.func,
  links: PropTypes.shape({
    newExpense: PropTypes.string,
    initiativeManage: PropTypes.string,
  })
};

export default compose(
  memo,
  withStyles(styles),
)(ExpenseList);
