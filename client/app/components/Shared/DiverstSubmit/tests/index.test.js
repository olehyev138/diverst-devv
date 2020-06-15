/**
 *
 * Tests for DiverstSubmit
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import DiverstSubmit from '../index';

describe('<DiverstSubmit />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstSubmit classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
