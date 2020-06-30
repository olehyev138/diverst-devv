/**
 *
 * Tests for UpdateListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { UpdateListPage } from '../index';

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
