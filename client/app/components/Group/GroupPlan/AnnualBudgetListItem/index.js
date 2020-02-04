/**
 *
 * AnnualBudget List Item Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { lighten, makeStyles, withStyles } from '@material-ui/core/styles';
import { floatRound, percent } from 'utils/floatRound';

import {
  Box, Grid, Typography, Divider, Card, CardContent, LinearProgress, CardHeader, Button, Link, Collapse
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstProgress from 'components/Shared/DiverstProgress';
import DiverstTable from '../../../Shared/DiverstTable';

const styles = theme => ({
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  dateText: {
    fontWeight: 'bold',
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

function InitiativeList({ initiatives, initiativeCount, handlePagination, handleOrdering, isLoading, ...rest }) {
  const columns = [
    {
      title: 'Event',
      field: 'name',
      query_field: 'initiative.name'
    },
    {
      title: 'Estimated funding',
      field: 'estimated_funding',
      query_field: 'estimated_funding',
      render: rowData => rowData.estimated_funding ? `$${floatRound(rowData.estimated_funding, 2)}` : '$0.00',
    },
    {
      title: 'Spent so far',
      field: 'current_expenses_sum',
      sorting: false,
      render: rowData => rowData.current_expenses_sum ? `$${floatRound(rowData.current_expenses_sum, 2)}` : '$0.00',
    },
    {
      title: 'Unspent',
      field: 'leftover',
      sorting: false,
      render: rowData => rowData.leftover ? `$${floatRound(rowData.leftover, 2)}` : '$0.00',
    },
    {
      title: 'Spending status',
      field: 'expenses_status',
      query_field: 'finished_expenses',
    },
  ];

  const handleOrderChange = (columnId, orderDir) => {
    handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  return (
    <DiverstTable
      handlePagination={handlePagination}
      onOrderChange={handleOrderChange}
      isLoading={isLoading}
      rowsPerPage={Math.min((initiatives || []).length, 10)}
      dataArray={initiatives || []}
      dataTotal={initiativeCount || 0}
      columns={columns}
    />
  );
}

export function AnnualBudgetListItem(props) {
  const { classes, item } = props;
  const { expenses, amount, available, approved, remaining } = item;

  const [initList, setInitList] = useState(false);

  const toggleList = () => {
    setInitList(!initList);
    if (!props.initiatives || props.initiatives.length <= 0)
      props.handlePagination({ count: 10, page: 0 });
  };

  return (
    <Card>
      <CardContent>
        <Typography variant='h5' align='left' color='primary'>
          {item.closed ? 'Past Annual Budget' : 'Current Annual Budget'}
        </Typography>
        <Box mb={2} />
        <Grid
          alignItems='flex-start'
          justify='flex-start'
          container
          spacing={1}
        >
          <Grid item>
            <Typography variant='body1' component='h2'>
              Budgets
            </Typography>
          </Grid>
          <Grid item>
            <Divider orientation='vertical' />
          </Grid>
          <Grid item>
            <Link
              className={classes.eventLink}
              component={WrappedNavLink}
              to={{
                pathname: props.links.budgetsIndex(item.id),
                annualBudget: item
              }}
            >
              <Typography color='primary' variant='body1' component='h2'>
                View Budget Requests
              </Typography>
            </Link>
          </Grid>
          { item.closed || (
            <React.Fragment>
              <Grid item>
                <Divider orientation='vertical' />
              </Grid>
              <Grid item>
                <Link
                  className={classes.eventLink}
                  component={WrappedNavLink}
                  to={{
                    pathname: props.links.newRequest(item.id),
                    annualBudget: item
                  }}
                >
                  <Typography color='primary' variant='body1' component='h2'>
                    Create Budget Request
                  </Typography>
                </Link>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
        <Grid
          alignItems='center'
          justify='center'
          container
          spacing={1}
        >
          <Grid item xs={1}>
            <Typography color='primary' variant='body1' component='h2'>
              Expenses
            </Typography>
            <Typography color='secondary' variant='body2' component='h2'>
              {`$${floatRound(expenses, 2)}`}
            </Typography>
          </Grid>
          <Grid item xs={10}>
            <DiverstProgress
              number={expenses}
              buffer={available}
              total={amount}
              overflow
            />
          </Grid>
          <Grid item xs={1}>
            <Typography color='primary' variant='body1' component='h2' align='right'>
              Annual Budget
            </Typography>
            <Typography color='secondary' variant='body2' component='h2' align='right'>
              {`$${floatRound(amount, 2)}`}
            </Typography>
          </Grid>
        </Grid>
        <Box mb={3} />
        <Grid container>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              Annual Budget
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              Approved budget
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              Available budget
            </Typography>
          </Grid>
        </Grid>
        <Divider />
        <Grid container>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {`$${floatRound(amount, 2)}`}
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {`$${floatRound(approved, 2)}`}
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {`$${floatRound(available, 2)}`}
            </Typography>
          </Grid>
        </Grid>
        <Box mb={2} />
        <Button
          color='primary'
          onClick={() => {
            toggleList();
          }}
        >
          Events Budget Info
        </Button>
      </CardContent>
      <Collapse in={initList}>
        <InitiativeList
          initiatives={props.initiatives}
          initiativeCount={props.initiativesTotal}
          isLoading={props.initiativesLoading}
          handlePagination={props.handlePagination}
          handleOrdering={props.handleOrdering}
          closeAction={() => setInitList(false)}
        />
      </Collapse>
    </Card>
  );
}

AnnualBudgetListItem.propTypes = {
  classes: PropTypes.object,
  item: PropTypes.object,
  links: PropTypes.object,
  initiatives: PropTypes.array,
  initiativesTotal: PropTypes.number,
  initiativesLoading: PropTypes.bool,
  handlePagination: PropTypes.func.isRequired,
  handleOrdering: PropTypes.func.isRequired,
};

InitiativeList.propTypes = {
  classes: PropTypes.object,
  initiatives: PropTypes.array,
  initiativeCount: PropTypes.number,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  isLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles),
)(AnnualBudgetListItem);
