/**
 *
 * Tests for BudgetsPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { BudgetsPage } from '../index';

import RouteService from 'utils/routeHelpers';

jest.mock('utils/routeHelpers');
RouteService.mockImplementation(() => ({
  location: {},
  params: jest.fn()
}));
const props = {
  getBudgetsBegin: jest.fn(),
  getAnnualBudgetBegin: jest.fn(),
  getAnnualBudgetSuccess: jest.fn(),
  budgetsUnmount: jest.fn()
};
describe('<BudgetsPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<BudgetsPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
