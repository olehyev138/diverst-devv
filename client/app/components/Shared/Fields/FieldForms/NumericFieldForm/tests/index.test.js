/**
 *
 * Tests for NumericFieldForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { NumericFieldForm } from '../index';

describe('<NumericFieldForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NumericFieldForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
