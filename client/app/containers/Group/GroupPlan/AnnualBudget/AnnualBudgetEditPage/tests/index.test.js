/**
 *
 * Tests for AnnualBudgetEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { AnnualBudgetEditPage } from '../index';

import RouteService from 'utils/routeHelpers';

jest.mock('utils/routeHelpers');
RouteService.mockImplementation(() => ({
  location: {},
  params: jest.fn()
}));

describe('<AnnualBudgetEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AnnualBudgetEditPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
