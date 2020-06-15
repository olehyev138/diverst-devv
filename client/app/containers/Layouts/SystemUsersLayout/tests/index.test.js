/**
 *
 * Tests for SystemUsersLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MockSystemUsersLayout from './mock';

describe('<SystemUsersLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MockSystemUsersLayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
