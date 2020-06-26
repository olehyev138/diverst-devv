/**
 *
 * Tests for DiverstDropdownMenu
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstDropdownMenu } from '../index';

const props = {
  setAnchor: jest.fn()
};
describe('<DiverstDropdownMenu />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstDropdownMenu classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
