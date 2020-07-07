/**
 *
 * Tests for UserGroupList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UserGroupList } from '../index';

const props = {
  defaultParams: {},
};
describe('<UserGroupList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserGroupList classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
