/**
 *
 * Tests for SignUpForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SignUpForm } from '../index';

describe('<SignUpForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SignUpForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
