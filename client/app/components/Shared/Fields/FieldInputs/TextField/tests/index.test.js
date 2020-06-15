/**
 *
 * Tests for CustomTextField
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomTextField from '../index';

describe('<CustomTextField />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomTextField classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
