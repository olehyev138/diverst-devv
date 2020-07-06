/**
 *
 * Tests for CustomTextForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { CustomTextForm } from '../index';

describe('<CustomTextForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomTextForm />);

    expect(spy).not.toHaveBeenCalled();
  });
});
