/**
 *
 * Tests for TextFieldForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { TextFieldForm } from '../index';

describe('<TextFieldForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<TextFieldForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
