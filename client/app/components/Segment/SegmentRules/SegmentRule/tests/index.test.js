/**
 *
 * Tests for SegmentRule
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import SegmentRule from '../index';

const props = {
  currentEnterprise: {}
};
describe('<SegmentRule />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentRule classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
