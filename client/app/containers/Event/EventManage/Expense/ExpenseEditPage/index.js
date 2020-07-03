/**
 *
 * ExpensesPage
 *
 *  - lists all enterprise custom expenses
 *  - renders forms for creating & editing custom expenses
 *
 *  - function:
 *    - get expenses from server
 *    - on edit - render respective form with expense data
 *    - on new - render respective empty form
 *    - on save - create/update expense
 */

import React, { memo, useEffect, useState } from 'react';
import { ROUTES } from 'containers/Shared/Routes/constants';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { useParams } from 'react-router-dom';

import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectIsCommitting, selectIsFetchingExpense, selectExpense
} from '../selectors';
import {
  getExpenseBegin, updateExpenseBegin, expensesUnmount
} from '../actions';

import reducer from '../reducer';
import saga from '../saga';

import { selectEvent } from 'containers/Event/selectors';
import { selectGroup } from 'containers/Group/selectors';
import ExpenseForm from 'components/Event/EventManage/ExpenseForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Event/EventManage/Expense/messages';
const { form: formMessages } = messages;

export function ExpenseCreatePage({ intl, ...props }) {
  useInjectReducer({ key: 'expenses', reducer });
  useInjectSaga({ key: 'expenses', saga });

  const [params, setParams] = useState(
    {
      count: 5,
      page: 0,
      order: 'asc',
      orderBy: 'initiative_expenses.id',
    }
  );

  const { expenses_id: expensesId } = useParams;
  const links = {
    index: ROUTES.group.plan.events.manage.expenses.index.path(props.currentGroup.id, props.currentEvent.id),
  };

  useEffect(() => {
    if (expensesId)
      props.getExpenseBegin({ id: expensesId });
    return () => props.expensesUnmount();
  }, []);

  return (
    <React.Fragment>
      <ExpenseForm
        initiativeId={props.currentEvent.id}
        currentEvent={props.currentEvent}
        currentGroup={props.currentGroup}
        isCommitting={props.isCommitting}
        isLoading={props.isLoading}
        expense={props.expense}
        expenseAction={props.updateExpenseBegin}
        buttonText={intl.formatMessage(formMessages.update)}
        links={links}
      />
    </React.Fragment>
  );
}

ExpenseCreatePage.propTypes = {
  intl: intlShape.isRequired,
  updateExpenseBegin: PropTypes.func.isRequired,
  getExpenseBegin: PropTypes.func.isRequired,
  expense: PropTypes.object,
  expensesUnmount: PropTypes.func.isRequired,
  isCommitting: PropTypes.bool,
  isLoading: PropTypes.bool,
  commitSuccess: PropTypes.bool,
  hasChanged: PropTypes.bool,
  currentEvent: PropTypes.shape({
    id: PropTypes.number
  }),
  currentGroup: PropTypes.shape({
    id: PropTypes.number
  })
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  currentEvent: selectEvent(),
  currentGroup: selectGroup(),
  isLoading: selectIsFetchingExpense(),
  expense: selectExpense(),
});

const mapDispatchToProps = {
  getExpenseBegin,
  updateExpenseBegin,
  expensesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  injectIntl,
)(ExpenseCreatePage);
