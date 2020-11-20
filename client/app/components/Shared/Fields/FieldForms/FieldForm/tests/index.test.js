/**
 *
 * Tests for FieldForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import FieldForm from '../index';

const props = {
  field: {}
};
describe('<FieldForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FieldForm classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});