/**
 *
 * Tests for GroupSelector
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MockGroupSelector from './index';

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
describe('<MockGroupSelector />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MockGroupSelector classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
