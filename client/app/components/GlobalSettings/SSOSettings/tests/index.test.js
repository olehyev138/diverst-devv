/**
 *
 * Tests for SSOSettings
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SSOSettings } from '../index';

describe('<SSOSettings />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SSOSettings classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
