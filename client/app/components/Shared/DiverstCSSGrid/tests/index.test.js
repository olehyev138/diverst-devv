/**
 *
 * Tests for DiverstCSSGrid
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstCSSGrid, DiverstCSSCell } from '../index';

describe('<DiverstCSSGrid />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstCSSGrid classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstCSSCell classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
