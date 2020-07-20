/**
 *
 * Tests for SegmentSelector
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import SegmentSelector from '../index';
import configureStore from 'redux-mock-store';
const mockStore = configureStore([]);

const props = {
  segmentField: '',
  label: <p></p>,
  handleChange: jest.fn(),
  setFieldValue: jest.fn(),
  values: {},
  getSegmentsBegin: jest.fn(),
  segments: [],
};
describe('<SegmentSelector />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SegmentSelector classes={{}} {...props} store={mockStore()} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
