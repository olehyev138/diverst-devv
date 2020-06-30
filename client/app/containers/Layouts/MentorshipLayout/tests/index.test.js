/**
 *
 * Tests for MentorshipLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MentorshipLayout from '../index';
import configureStore from 'redux-mock-store';
const mockStore = configureStore([]);

describe('<MentorshipLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MentorshipLayout classes={{}} store={mockStore()} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
