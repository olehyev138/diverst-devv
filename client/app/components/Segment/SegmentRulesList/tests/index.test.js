/**
 *
 * Tests for SegmentRules
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SegmentRules } from '../index';

describe('<SegmentRules />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentRules classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
