/**
 *
 * Tests for UserRoleListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UserRoleListPage } from '../index';
import 'utils/mockReactRouterHooks';

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
