/**
 *
 * Tests for GroupManageLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MockGroupManageLayout from './mock';

describe('<GroupManageLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MockGroupManageLayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
