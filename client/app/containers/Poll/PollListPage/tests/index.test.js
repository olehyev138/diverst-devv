/**
 *
 * Tests for PollListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { PollListPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getPollsBegin: jest.fn(),
  pollsUnmount: jest.fn(),
};

describe('<PollListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<PollListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
