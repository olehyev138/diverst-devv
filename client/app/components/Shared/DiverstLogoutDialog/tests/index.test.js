/**
 *
 * Tests for DiverstLogoutDialog
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstLogoutDialog } from '../index';

describe('<DiverstLogoutDialog />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstLogoutDialog classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
