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
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  expenseAction: jest.fn(),
  links: {}
};

describe('<ExpenseForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<ExpenseForm intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
