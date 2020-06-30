/**
 *
 * Tests for GroupMessagePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupMessagePage } from '../index';
import 'utils/mockReactRouterHooks';

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
