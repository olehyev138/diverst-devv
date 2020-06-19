/**
 *
 * Tests for Logo
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { Logo } from '../index';

describe('<Logo />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<Logo classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
