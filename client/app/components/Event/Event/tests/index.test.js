/**
 *
 * Tests for Event
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';

import { Event } from '../index';

describe('<Event />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<Event classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
