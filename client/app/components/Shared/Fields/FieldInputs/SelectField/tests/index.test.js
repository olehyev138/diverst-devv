/**
 *
 * Tests for CustomSelectField
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomSelectField from '../index';

describe('<CustomSelectField />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomSelectField classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});