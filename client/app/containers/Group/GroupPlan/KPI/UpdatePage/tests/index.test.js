/**
 *
 * Tests for UpdatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UpdatePage } from '../index';

import RouteService from 'utils/routeHelpers';

jest.mock('utils/routeHelpers');
RouteService.mockImplementation(() => ({
  location: {},
}));
const props = {
  getUpdateBegin: jest.fn(),
  getUpdateSuccess: jest.fn(),
  deleteUpdateBegin: jest.fn(),
  updateUpdateBegin: jest.fn(),
  updateFieldDataBegin: jest.fn(),
  updatesUnmount: jest.fn()
};
describe('<UpdatePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UpdatePage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
