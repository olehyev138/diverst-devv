/**
 *
 * Tests for Toggles
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { Toggles } from '../index';

const props = {
  toggles: {}
};
describe('<Toggles />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<Toggles classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
