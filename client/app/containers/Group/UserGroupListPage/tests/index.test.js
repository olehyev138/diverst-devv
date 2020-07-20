/**
 *
 * Tests for UserGroupListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { UserGroupListPage } from '../index';

const props = {
  getGroupsBegin: jest.fn(),
  groupListUnmount: jest.fn(),
};
describe('<UserGroupListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserGroupListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});