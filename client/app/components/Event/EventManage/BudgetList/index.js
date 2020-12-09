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
import { toCurrencyString } from 'utils/currencyHelpers';
import ExpenseList from "components/Event/EventManage/ExpensesList";

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

export function BudgetList(props, context) {
  const { initiative } = props;
  return (
    initiative && (initiative.budget_users.length ? (
      initiative.budget_users.map(budgetUser => (
        <React.Fragment>
          <ExpenseList
            budgetUser={budgetUser}
            expenses={budgetUser.expenses}
            expenseTotal={budgetUser.expenses.length}
            expenseSumTotal={budgetUser.spent}
            {...props}
          />
        </React.Fragment>
      ))
    ) : (
      <Grid item align='center'>
        <Typography color='secondary' variant='h5' component='h2'>
          <DiverstFormattedMessage {...messages.free} />
        </Typography>
      </Grid>
    )
    ));
}

BudgetList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  initiative: PropTypes.object,
  currentGroup: PropTypes.object,
  expenses: PropTypes.array,
  expenseTotal: PropTypes.number,
  expenseSumTotal: PropTypes.string,
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
  }),
  customTexts: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(BudgetList);
