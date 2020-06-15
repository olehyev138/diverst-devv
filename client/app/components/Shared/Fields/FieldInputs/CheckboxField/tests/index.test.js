/**
 *
 * Tests for CustomCheckboxField
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomCheckboxField from '../index';

describe('<CustomCheckboxField />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomCheckboxField classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
