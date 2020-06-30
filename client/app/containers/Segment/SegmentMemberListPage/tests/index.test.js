/**
 *
 * Tests for SegmentMemberListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { SegmentMemberListPage } from '../index';

const props = {
  getUsersBegin: jest.fn(),
  userUnmount: jest.fn(),
};
describe('<SegmentMemberListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentMemberListPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
