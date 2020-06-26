/**
 *
 * Tests for DiverstCalendar
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstCalendar } from '../index';

describe('<DiverstCalendar />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstCalendar classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
