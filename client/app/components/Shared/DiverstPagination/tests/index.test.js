/**
 *
 * Tests for DiverstPagination
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstPagination } from '../index';

const props = {
  handlePagination: jest.fn()
};
describe('<DiverstPagination />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstPagination classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
