/**
 *
 * Tests for DiverstDateTimePicker
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstDateTimePicker } from '../index';

const props = {
  field: { name: 'name' },
  form: { errors: {} }
};

describe('<DiverstDateTimePicker />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstDateTimePicker classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
