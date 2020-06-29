/**
 *
 * Tests for NewsFeedPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { NewsFeedPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getUserPostsBegin: jest.fn(),
  userUnmount: jest.fn(),
  currentEnterprise: {}
};

describe('<NewsFeedPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NewsFeedPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
