/**
 *
 * Tests for CustomDateField
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomDateField from '../index';

describe('<CustomDateField />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomDateField classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
