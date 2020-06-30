/**
 *
 * Tests for EventPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { EventPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  currentUser: {}
};
describe('<EventPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<EventPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
