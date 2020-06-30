/**
 *
 * Tests for GroupManageLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import GroupManageLayout from '../index';
import configureStore from 'redux-mock-store';
const mockStore = configureStore([]);

describe('<GroupManageLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupManageLayout classes={{}} store={mockStore()} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
