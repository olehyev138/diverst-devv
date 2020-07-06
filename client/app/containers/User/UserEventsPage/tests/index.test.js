/**
 *
 * Tests for EventsPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { EventsPage } from '../index';

const props = {
  getUserEventsBegin: jest.fn(),
  userUnmount: jest.fn(),
};

describe('<EventsPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<EventsPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
