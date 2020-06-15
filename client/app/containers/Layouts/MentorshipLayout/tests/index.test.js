/**
 *
 * Tests for MentorshipLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MockMentorshipLayout from './mock';

describe('<MentorshipLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MockMentorshipLayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
