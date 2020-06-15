/**
 *
 * Tests for AnnualBudgetList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { AnnualBudgetList } from '../index';
const props = {
  annualBudgets: [],
  defaultParams: {}
};
describe('<AnnualBudgetList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AnnualBudgetList classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
