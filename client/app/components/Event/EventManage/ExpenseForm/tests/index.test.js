/**
 *
 * Tests for ExpenseForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { ExpenseForm } from '../index';

loadTranslation('./app/translations/en.json');
const props = {
  expenseAction: jest.fn(),
  links: {}
};

describe('<ExpenseForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<ExpenseForm {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
