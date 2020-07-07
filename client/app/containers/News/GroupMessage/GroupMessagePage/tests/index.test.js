/**
 *
 * Tests for GroupMessagePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { GroupMessagePage } from '../index';

const props = {
  currentUser: {}
};

describe('<GroupMessagePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupMessagePage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
