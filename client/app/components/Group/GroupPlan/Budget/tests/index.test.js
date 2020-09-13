/**
 *
 * Tests for Budget
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { Budget } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  approveAction: jest.fn(),
  declineAction: jest.fn(),
  closeBudgetAction: jest.fn(),
};
describe('<Budget />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<Budget intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});