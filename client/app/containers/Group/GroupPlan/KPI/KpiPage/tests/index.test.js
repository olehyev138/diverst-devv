/**
 *
 * Tests for KPIPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { KPIPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getMetricsBegin: jest.fn(),
  updatesUnmount: jest.fn()
};
describe('<KPIPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<KPIPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
