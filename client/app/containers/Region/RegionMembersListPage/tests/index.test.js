/**
 *
 * Tests for RegionMembersListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { RegionMembersListPage } from '../index';

describe('<RegionMembersListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<RegionMembersListPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
