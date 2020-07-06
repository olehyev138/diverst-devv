/**
 *
 * Tests for DiverstSelect
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstSelect } from '../index';

describe('<DiverstSelect />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstSelect classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
