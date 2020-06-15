/**
 *
 * Tests for BudgetLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MockBudgetLayout from './mock';

describe('<BudgetLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MockBudgetLayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
