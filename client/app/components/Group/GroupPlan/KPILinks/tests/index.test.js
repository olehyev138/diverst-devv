/**
 *
 * Tests for KPILinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { KPILinks } from '../index';

const props = {
  currentGroup: {}
};
describe('<KPILinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<KPILinks classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
