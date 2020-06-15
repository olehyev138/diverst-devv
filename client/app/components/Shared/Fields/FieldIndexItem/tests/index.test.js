/**
 *
 * Tests for FieldList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { FieldList } from '../index';

const props = {
  field: {}
};
describe('<FieldList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FieldList classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
