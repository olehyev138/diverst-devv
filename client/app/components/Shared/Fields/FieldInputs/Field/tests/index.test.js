/**
 *
 * Tests for CustomField
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomField from '../index';

describe('<CustomField />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomField classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
