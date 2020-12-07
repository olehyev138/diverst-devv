/**
 *
 * Tests for AdminAnnualBudgetPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { AdminInitializeBudgetPage } from '../index';

const props = {
  getAnnualBudgetsBegin: jest.fn(),
  groupAllUnmount: jest.fn(),
  carryBudgetBegin: jest.fn(),
  resetBudgetBegin: jest.fn(),
  handleVisitEditPage: jest.fn(),
};
describe('<AdminAnnualBudgetPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AdminInitializeBudgetPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
