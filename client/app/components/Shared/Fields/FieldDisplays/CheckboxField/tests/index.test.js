/**
 *
 * Tests for CustomCheckbox
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomCheckbox from '../index';

const props = {
  fieldDatum: { data: [],
    field: {} }
};
describe('<CustomCheckbox />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomCheckbox classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
