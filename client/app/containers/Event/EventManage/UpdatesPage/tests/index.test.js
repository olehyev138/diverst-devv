/**
 *
 * Tests for UpdateListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UpdateListPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getUpdatesBegin: jest.fn(),
  updatesUnmount: jest.fn(),
};
describe('<UpdateListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UpdateListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
