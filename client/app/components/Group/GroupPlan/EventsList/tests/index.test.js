/**
 *
 * Tests for EventsList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { EventsList } from '../index';

const props = {
  links: {}
};
describe('<EventsList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<EventsList classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
