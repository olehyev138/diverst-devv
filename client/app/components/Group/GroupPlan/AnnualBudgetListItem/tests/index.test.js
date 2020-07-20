/**
 *
 * Tests for AnnualBudgetListItem
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { AnnualBudgetListItem } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  handlePagination: jest.fn(),
  handleOrdering: jest.fn(),
  item: {},
  links: {
    budgetsIndex: jest.fn(),
    newRequest: jest.fn(),
  }
};
describe('<AnnualBudgetListItem />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<AnnualBudgetListItem classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
