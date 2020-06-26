/**
 *
 * Tests for EventForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
// import { EventForm } from '../index';
import { shallow } from 'enzyme';

const props = {
  currentGroup: {},
};

// Todo: TypeError: Invalid URL
describe('<EventForm />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallow(<EventForm {...props} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
