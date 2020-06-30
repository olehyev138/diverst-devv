/**
 *
 * Tests for GroupMemberListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { GroupMemberListPage } from '../index';

describe('<GroupMemberListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupMemberListPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
