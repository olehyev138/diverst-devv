/**
 *
 * Tests for CustomDate
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import CustomDate from '../index';

const props = {
  fieldDatum: { field: {} }
};
describe('<CustomDate />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<CustomDate classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
