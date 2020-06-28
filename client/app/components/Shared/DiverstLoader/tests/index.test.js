/**
 *
 * Tests for DiverstLoader
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import DiverstLoader from '../index';

const props = {
  children: <p></p>
};
describe('<DiverstLoader />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstLoader classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
