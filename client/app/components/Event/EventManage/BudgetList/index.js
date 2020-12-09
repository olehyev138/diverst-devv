/**
 *
 * ExpenseList Component
 *
 *
 */

import React, {
  memo, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Typography, Grid, Tab, Paper,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Event/EventManage/Expense/messages';
import { injectIntl, intlShape } from 'react-intl';
import ExpenseList from 'components/Event/EventManage/ExpensesList';
import ResponsiveTabs from 'components/Shared/ResponsiveTabs';

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
  const [tab, setTab] = useState(0);

  if (initiative) {
    if (props.budgetUsers.length > 0)
      return (
        <React.Fragment>
          <Paper>
            <ResponsiveTabs
              value={tab}
              onChange={(_, a) => setTab(a)}
              indicatorColor='primary'
              textColor='primary'
            >
              {props.budgetUsers.map(budgetUser => (
                <Tab label={budgetUser.budget_item.title} key={budgetUser.id} />
              ))}
            </ResponsiveTabs>
          </Paper>
          <React.Fragment>
            <ExpenseList
              budgetUser={props.budgetUsers[tab]}
              expenses={props.budgetUsers[tab].expenses}
              expenseTotal={props.budgetUsers[tab].expenses.length}
              expenseSumTotal={props.budgetUsers[tab].spent}
              {...props}
            />
          </React.Fragment>
        </React.Fragment>
      );

    if (props.isLoading)
      return <React.Fragment />;

    return (
      <Grid item align='center'>
        <Typography color='secondary' variant='h5' component='h2'>
          <DiverstFormattedMessage {...messages.free} />
        </Typography>
      </Grid>
    );
  }
  return <React.Fragment />;
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
  isLoading: PropTypes.bool,
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
  budgetUsers: PropTypes.array,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(BudgetList);
