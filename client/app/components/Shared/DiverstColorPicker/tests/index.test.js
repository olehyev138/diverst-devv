/**
 *
 * Tests for DiverstColorPicker
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstColorPicker } from '../index';

const props = {
  theme: { palette: { primary: {} } }
};
describe('<DiverstColorPicker />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstColorPicker classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
