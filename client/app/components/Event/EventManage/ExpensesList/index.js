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
import { floatRound, percent } from 'utils/floatRound';

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
import messages from 'containers/Event/EventManage/Expense/messages';
import DiverstProgress from 'components/Shared/DiverstProgress';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import AddIcon from '@material-ui/icons/Add';
import { injectIntl, intlShape } from 'react-intl';

const beforeNowString = datetime => DateTime.local() > DateTime.fromISO(datetime);
const beforeNowTime = datetime => DateTime.local() > datetime;

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

export function ExpenseList(props, context) {
  const { classes, initiative, intl } = props;

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: intl.formatMessage(messages.columns.description),
      field: 'description',
      query_field: 'description',
    },
    {
      title: intl.formatMessage(messages.columns.amount),
      field: 'amount',
      query_field: 'amount',
      render: rowData => rowData.amount ? `$${floatRound(rowData.amount, 2)}` : '$0.00',
    },
    {
      title: intl.formatMessage(messages.columns.createdAt),
      field: 'created_at',
      query_field: 'created_at',
      render: rowData => formatDateTimeString(rowData.created_at, DateTime.DATE_MED)
    },
  ];

  const actions = [];

  if (initiative && !initiative.finished_expenses) {
    actions.push({
      icon: () => <EditIcon />,
      tooltip: intl.formatMessage(messages.actions.edit),
      onClick: (_, rowData) => {
        props.links.editExpense(rowData.id);
      }
    });

    actions.push({
      icon: () => <DeleteIcon />,
      tooltip: intl.formatMessage(messages.actions.delete),
      onClick: (_, rowData) => {
        props.deleteExpenseBegin({ id: rowData.id });
      }
    });
  }

  return (
    initiative && (initiative.budget_item ? (
      <React.Fragment>
        <CardContent>
          <Grid
            container
            alignContent='space-between'
            spacing={2}
            alignItems='flex-end'
            justify='flex-end'
          >
            { initiative && !initiative.finished_expenses ? (
              <React.Fragment>
                <Grid item align='right'>
                  <Button
                    color='primary'
                    variant='contained'
                    to={props.links.newExpense}
                    component={WrappedNavLink}
                    startIcon={<AddIcon />}
                  >
                    <DiverstFormattedMessage {...messages.buttons.new} />
                  </Button>
                </Grid>
                { props.initiative && beforeNowString(props.initiative.end) && (
                  <Grid item align='right'>
                    <DiverstSubmit
                      color='secondary'
                      variant='contained'
                      onClick={() => {
                        // eslint-disable-next-line no-restricted-globals,no-alert
                        if (intl.formatMessage(messages.buttons.closeConfirm))
                          props.finalizeExpensesBegin({ id: props.initiative.id });
                      }}
                    >
                      <DiverstFormattedMessage {...messages.buttons.close} />
                    </DiverstSubmit>
                  </Grid>
                )}
              </React.Fragment>
            ) : (
              <Grid item align='right'>
                <Typography color='secondary' variant='h5' component='h2'>
                  <DiverstFormattedMessage {...messages.close} />
                </Typography>
              </Grid>
            )}

          </Grid>
        </CardContent>
        <Grid container spacing={3}>
          <Grid item xs>
            <DiverstTable
              title={intl.formatMessage(messages.title)}
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
            <Typography variant='h6' component='h2'>
              <DiverstFormattedMessage {...messages.pressure} />
            </Typography>
            <Box mb={2} />
            <Grid
              alignItems='center'
              justify='center'
              container
              spacing={1}
            >
              <Grid item xs={1}>
                <Typography color='primary' variant='body1' component='h2'>
                  {initiative.finished_expenses
                    ? <DiverstFormattedMessage {...messages.final} />
                    : <DiverstFormattedMessage {...messages.total} />}
                </Typography>
                <Typography color='secondary' variant='body2' component='h2'>
                  {`$${floatRound(props.expenseSumTotal, 2)}`}
                </Typography>
              </Grid>
              <Grid item xs={10}>
                {props.expenseSumTotal && (
                  <DiverstProgress
                    number={props.expenseSumTotal}
                    total={props.initiative.estimated_funding}
                    overflow
                  />
                )}
              </Grid>
              <Grid item xs={1}>
                <Typography color='primary' variant='body1' component='h2' align='right'>
                  <DiverstFormattedMessage {...messages.estimated} />
                </Typography>
                <Typography color='secondary' variant='body2' component='h2' align='right'>
                  {`$${floatRound(props.initiative.estimated_funding, 2)}`}
                </Typography>
              </Grid>
            </Grid>
          </CardContent>
        </Card>
      </React.Fragment>
    ) : (
      <Grid item align='center'>
        <Typography color='secondary' variant='h5' component='h2'>
          <DiverstFormattedMessage {...messages.free} />
        </Typography>
      </Grid>
    )
    ));
}

ExpenseList.propTypes = {
  intl: intlShape,
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
  finalizeExpensesBegin: PropTypes.func,
  links: PropTypes.shape({
    newExpense: PropTypes.string,
    initiativeManage: PropTypes.string,
    editExpense: PropTypes.func,
  })
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(ExpenseList);
