/**
 *
 * Tests for FieldListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { FieldListPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getFieldsBegin: jest.fn(),
  createFieldBegin: jest.fn(),
  updateFieldBegin: jest.fn(),
  fieldUnmount: jest.fn()
};
describe('<FieldListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FieldListPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
