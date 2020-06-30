/**
 *
 * Tests for SegmentListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { SegmentListPage } from '../index';

const props = {
  getSegmentsBegin: jest.fn(),
  segmentUnmount: jest.fn(),
};
describe('<SegmentListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
