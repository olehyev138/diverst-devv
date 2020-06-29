/**
 *
 * Tests for PolicyEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { PolicyEditPage } from '../index';
import 'utils/mockReactRouterHooks';

describe('<PolicyEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<PolicyEditPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
