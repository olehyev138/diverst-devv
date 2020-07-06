/**
 *
 * Tests for GroupSelector
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import GroupSelector from '../index';
import configureStore from 'redux-mock-store';
const mockStore = configureStore([]);

const props = {
  groupField: '',
  label: <p></p>,
  handleChange: jest.fn(),
  setFieldValue: jest.fn(),
  values: {},
  queryScopes: [],
  getGroupsBegin: jest.fn(),
  groupListUnmount: jest.fn(),
  groups: [],
};
describe('<GroupSelector />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupSelector classes={{}} {...props} store={mockStore()} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
