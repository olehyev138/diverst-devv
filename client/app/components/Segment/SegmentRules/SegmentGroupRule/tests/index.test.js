/**
 *
 * Tests for SegmentGroupRule
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import SegmentGroupRule from '../index';

const props = {
  currentEnterprise: {}
};
describe('<SegmentGroupRule />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentGroupRule classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
