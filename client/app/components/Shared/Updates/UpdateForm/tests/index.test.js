/**
 *
 * Tests for UpdateForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UpdateForm } from '../index';

const props = {
  updateAction: jest.fn(),
  links: {}
};
describe('<UpdateForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UpdateForm classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
