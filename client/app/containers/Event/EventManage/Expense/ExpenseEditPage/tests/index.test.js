/**
 *
 * Tests for ExpenseEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import 'utils/mockReactRouterHooks';
import { ExpenseEditPage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

const props = {
  expensesUnmount: jest.fn(),
  getExpenseBegin: jest.fn(),
  updateExpenseBegin: jest.fn(),
  currentGroup: {},
  currentEvent: {}
};
describe('<ExpenseEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<ExpenseEditPage classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
