/**
 *
 * Tests for SegmentFieldRule
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import SegmentFieldRule from '../index';

const props = {
  currentEnterprise: {}
};
describe('<SegmentFieldRule />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentFieldRule classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
