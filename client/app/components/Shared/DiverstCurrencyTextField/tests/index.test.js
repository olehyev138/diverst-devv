/**
 *
 * Tests for DiverstCurrencyTextField
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstCurrencyTextField } from '../index';

const props = {
  onChange: jest.fn(),
  name: '',
  id: ''
};
describe('<DiverstCurrencyTextField />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstCurrencyTextField classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
