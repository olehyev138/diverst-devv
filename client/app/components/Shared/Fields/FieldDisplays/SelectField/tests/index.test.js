/**
 *
 * Tests for CustomSelect
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomSelect from '../index';

const props = {
  fieldDatum: { field: {},
    data: [] }
};
describe('<CustomSelect />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomSelect classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
