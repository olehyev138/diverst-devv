/**
 *
 * Tests for BudgetForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { BudgetForm } from '../index';

const props = {
  budgetAction: jest.fn(),
  links: {}
};
describe('<BudgetForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<BudgetForm classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
