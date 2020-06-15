/**
 *
 * Tests for KPILayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import KPILayout from '../index';

describe('<KPILayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<KPILayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
