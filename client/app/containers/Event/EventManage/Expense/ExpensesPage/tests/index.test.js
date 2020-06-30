/**
 *
 * Tests for ExpenseListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { ExpenseListPage } from '../index';

const props = {
  getExpensesBegin: jest.fn(),
  createExpenseBegin: jest.fn(),
  updateExpenseBegin: jest.fn(),
  handleVisitEditPage: jest.fn(),
  finalizeExpensesBegin: jest.fn(),
  expensesUnmount: jest.fn(),
  currentGroup: {},
  currentEvent: {}
};
describe('<ExpenseListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ExpenseListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
