/**
 *
 * Tests for GroupManageLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupManageLinks } from '../index';

const props = {
  currentGroup: {}
};
describe('<GroupManageLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupManageLinks classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
