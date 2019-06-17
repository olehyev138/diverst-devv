/**
 *
 * Tests for LoginPage
 *
 *
 */


/**
 * TODO:
 *   - Test it renders correct child component given enterprise prop
 *   - Test it dispatches correct actions
 *   - Test it uses props correctly
 */

import React from 'react';
import { shallow } from 'enzyme';

import { LoginPage } from 'containers/Session/LoginPage/index';

describe('<LoginPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<LoginPage />);

    expect(spy).not.toHaveBeenCalled();
  });
});
