/**
 *
 * Tests for GroupLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { GroupLinks } from '../index';

describe('<GroupLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupLinks classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
