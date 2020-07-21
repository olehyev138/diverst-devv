/**
 *
 * Tests for GroupLeadersListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { GroupLeadersListPage } from '../index';

describe('<GroupLeadersListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupLeadersListPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
