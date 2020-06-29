/**
 *
 * Tests for UserListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UserListPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getUsersBegin: jest.fn(),
  userUnmount: jest.fn(),
};
describe('<UserListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
