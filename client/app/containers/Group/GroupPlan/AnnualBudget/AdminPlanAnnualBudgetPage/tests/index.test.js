/**
 *
 * Tests for AdminAnnualBudgetPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { AdminAnnualBudgetPage } from '../index';

import RouteService from 'utils/routeHelpers';

jest.mock('utils/routeHelpers');
RouteService.mockImplementation(() => ({
  location: {},
}));
const props = {
  getAnnualBudgetsBegin: jest.fn(),
  groupListUnmount: jest.fn(),
  carryBudgetBegin: jest.fn(),
  resetBudgetBegin: jest.fn(),
  handleVisitEditPage: jest.fn(),
};
describe('<AdminAnnualBudgetPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AdminAnnualBudgetPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
