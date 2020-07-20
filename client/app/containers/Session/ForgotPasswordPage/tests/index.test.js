/**
 *
 * Tests for ForgotPasswordPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { ForgotPasswordPage } from '../index';

const props = {
  getLogsBegin: jest.fn(),
  logUnmount: jest.fn()
};
describe('<ForgotPasswordPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ForgotPasswordPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
