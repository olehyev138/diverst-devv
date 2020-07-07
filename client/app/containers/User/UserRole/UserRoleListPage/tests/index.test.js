/**
 *
 * Tests for UserRoleListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { UserRoleListPage } from '../index';

const props = {
  getUserRolesBegin: jest.fn(),
  userRoleUnmount: jest.fn(),
};
describe('<UserRoleListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserRoleListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
