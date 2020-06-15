/**
 *
 * Tests for DiverstTable
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstTable } from '../index';

const props = {
  dataArray: [],
  columns: [],
  handlePagination: jest.fn()
};
describe('<DiverstTable />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstTable classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
