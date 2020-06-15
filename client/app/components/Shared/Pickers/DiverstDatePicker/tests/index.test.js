/**
 *
 * Tests for DiverstDatePicker
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstDatePicker } from '../index';

const props = {
  field: { name: 'name' },
  form: { errors: {} }
};
describe('<DiverstDatePicker />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstDatePicker classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
