/**
 *
 * Tests for BudgetPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { BudgetPage } from '../index';

import RouteService from 'utils/routeHelpers';

jest.mock('utils/routeHelpers');
RouteService.mockImplementation(() => ({
  location: {},
}));

describe('<BudgetPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<BudgetPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
