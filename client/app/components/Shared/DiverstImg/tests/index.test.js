/**
 *
 * Tests for DiverstImg
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstImg } from '../index';

const props = {
  data: ''
};
describe('<DiverstImg />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstImg classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
