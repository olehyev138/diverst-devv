/**
 *
 * Tests for GroupRegionsListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { GroupRegionsListPage } from '../index';

describe('<GroupRegionsListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupRegionsListPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
