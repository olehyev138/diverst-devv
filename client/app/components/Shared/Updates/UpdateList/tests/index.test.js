/**
 *
 * Tests for UpdateList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UpdateList } from '../index';

const props = {
  links: {}
};
describe('<UpdateList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UpdateList classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
