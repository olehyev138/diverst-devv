/**
 *
 * Tests for SystemUsersLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SystemUsersLinks } from '../index';

describe('<SystemUsersLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SystemUsersLinks classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
