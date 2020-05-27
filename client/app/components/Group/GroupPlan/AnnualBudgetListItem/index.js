/**
 *
 * AnnualBudget List Item Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { lighten, makeStyles, withStyles } from '@material-ui/core/styles';
import { floatRound, percent, clamp } from 'utils/floatRound';

import {
  Box, Grid, Typography, Divider, Card, CardContent, LinearProgress, CardHeader, Button, Link, Collapse
} from '@material-ui/core';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstProgress from 'components/Shared/DiverstProgress';
import DiverstTable from 'components/Shared/DiverstTable';
import { injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupPlan/AnnualBudget/messages';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import {toCurrencyString} from "utils/currencyHelpers";

const { events: eventMessages } = messages;
const { item: itemMessages } = messages;

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

function InitiativeList({ initiatives, initiativeCount, handlePagination, handleOrdering, isLoading, links, intl, ...rest }) {
  const columns = [
    {
      title: intl.formatMessage(eventMessages.columns.name),
      field: 'name',
      query_field: 'initiative.name',
      render: rowData => (
        <Typography color='primary' variant='body1'>
          <Link
            href={links.eventExpenses(rowData.id)}
          >
            {rowData.name}
          </Link>
        </Typography>
      )
    },
    {
      title: intl.formatMessage(eventMessages.columns.funding),
      field: 'estimated_funding',
      query_field: 'estimated_funding',
      render: rowData => toCurrencyString(intl, rowData.estimated_funding || 0),
    },
    {
      title: intl.formatMessage(eventMessages.columns.spent),
      field: 'current_expenses_sum',
      sorting: false,
      render: rowData => toCurrencyString(intl, rowData.current_expenses_sum || 0),
    },
    {
      title: intl.formatMessage(eventMessages.columns.unspent),
      field: 'leftover',
      sorting: false,
      render: rowData => toCurrencyString(intl, rowData.leftover || 0),
    },
    {
      title: intl.formatMessage(eventMessages.columns.status),
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
    initiatives ? (
      <DiverstTable
        handlePagination={handlePagination}
        onOrderChange={handleOrderChange}
        isLoading={isLoading}
        title={intl.formatMessage(eventMessages.title)}
        rowsPerPage={clamp((initiatives || []).length, 1, 5)}
        dataArray={initiatives || []}
        dataTotal={initiativeCount || 0}
        columns={columns}
        my_options={{
          search: false
        }}
      />
    ) : (
      <React.Fragment />
    )
  );
}

export function AnnualBudgetListItem(props) {
  const { classes, links, item, intl } = props;
  const { expenses, amount, available, approved, remaining, estimated, unspent, currency } = item;

  const [initList, setInitList] = useState(false);

  const toggleList = () => {
    setInitList(!initList);
    if (!props.initiatives || props.initiatives.length <= 0)
      props.handlePagination({ count: 5, page: 0 });
  };

  return (
    <Card>
      <CardContent>
        <Typography variant='h5' align='left' color='primary'>
          {item.closed
            ? <DiverstFormattedMessage {...itemMessages.pastTitle} />
            : <DiverstFormattedMessage {...itemMessages.currentTitle} />}
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
              <DiverstFormattedMessage {...itemMessages.budget} />
            </Typography>
          </Grid>
          <Grid item>
            <Divider orientation='vertical' />
          </Grid>
          <Permission show={permission(props.currentGroup, 'budgets_create?')}>
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
                  <DiverstFormattedMessage {...itemMessages.viewRequests} />
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
                      <DiverstFormattedMessage {...itemMessages.createRequests} />
                    </Typography>
                  </Link>
                </Grid>
              </React.Fragment>
            )}
          </Permission>
        </Grid>
        <Grid
          alignItems='center'
          justify='center'
          container
          spacing={1}
        >
          <Grid item xs={false} sm={2} md={1}>
            <Typography color='primary' variant='body1' component='h2'>
              <DiverstFormattedMessage {...itemMessages.expenses} />
            </Typography>
            <Typography color='secondary' variant='body2' component='h2'>
              {toCurrencyString(props.intl, expenses || 0, currency)}
            </Typography>
          </Grid>
          <Grid item xs={12} sm={8} md={10}>
            <DiverstProgress
              number={expenses}
              buffer={approved}
              total={amount}
              overflow
            />
          </Grid>
          <Grid item xs={false} sm={2} md={1}>
            <Typography color='primary' variant='body1' component='h2' align='right'>
              <DiverstFormattedMessage {...itemMessages.annualBudget} />
            </Typography>
            <Typography color='secondary' variant='body2' component='h2' align='right'>
              {toCurrencyString(props.intl, amount || 0, currency)}
            </Typography>
          </Grid>
        </Grid>
        <Box mb={3} />
        <Grid container>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              <DiverstFormattedMessage {...itemMessages.annualBudget} />
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              <DiverstFormattedMessage {...itemMessages.approvedBudget} />
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              <DiverstFormattedMessage {...itemMessages.availableBudget} />
            </Typography>
          </Grid>
        </Grid>
        <Divider />
        <Grid container>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {toCurrencyString(props.intl, amount || 0, currency)}
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {toCurrencyString(props.intl, approved || 0, currency)}
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {toCurrencyString(props.intl, available || 0, currency)}
            </Typography>
          </Grid>
        </Grid>
        <Box mb={3} />
        <Grid container>
          <Grid item xs={6}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              <DiverstFormattedMessage {...itemMessages.estimatedExpenses} />
            </Typography>
          </Grid>
          <Grid item xs={6}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              <DiverstFormattedMessage {...itemMessages.eventUnspent} />
            </Typography>
          </Grid>
        </Grid>
        <Divider />
        <Grid container>
          <Grid item xs={6}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {toCurrencyString(props.intl, estimated || 0, currency)}
            </Typography>
          </Grid>
          <Grid item xs={6}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {toCurrencyString(props.intl, unspent || 0, currency)}
            </Typography>
          </Grid>
        </Grid>
        <Box mb={2} />
        <Button
          color='primary'
          variant='contained'
          onClick={() => {
            toggleList();
          }}
        >
          <DiverstFormattedMessage {...eventMessages.title} />
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
          links={links}
          intl={intl}
        />
      </Collapse>
    </Card>
  );
}

AnnualBudgetListItem.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  currentGroup: PropTypes.object,
  item: PropTypes.object,
  links: PropTypes.object,
  initiatives: PropTypes.array,
  initiativesTotal: PropTypes.number,
  initiativesLoading: PropTypes.bool,
  handlePagination: PropTypes.func.isRequired,
  handleOrdering: PropTypes.func.isRequired,
};

InitiativeList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  initiatives: PropTypes.array,
  initiativeCount: PropTypes.number,
  links: PropTypes.object,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  isLoading: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(AnnualBudgetListItem);
