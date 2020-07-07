/**
 *
 * Tests for SegmentForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SegmentForm } from '../index';
const props = {
  currentEnterprise: {}
};
describe('<SegmentForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentForm classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
