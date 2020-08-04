/**
 *
 * Tests for Event
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { PasswordResetPage } from '../index';

const props = {
  currentUser: {}
};
describe('<PasswordResetPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<PasswordResetPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
