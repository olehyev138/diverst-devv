/**
 *
 * Tests for Scrollbar
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { Scrollbar } from '../index';

const props = {
  children: <p></p>
};
describe('<Scrollbar />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<Scrollbar classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
