/**
 *
 * Tests for Permission
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import Permission from '../index';

describe('<Permission />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<Permission classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
