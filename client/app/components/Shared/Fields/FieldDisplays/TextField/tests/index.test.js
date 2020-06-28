/**
 *
 * Tests for CustomText
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomText from '../index';

const props = {
  fieldDatum: { field: {} }
};
describe('<CustomText />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomText classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
