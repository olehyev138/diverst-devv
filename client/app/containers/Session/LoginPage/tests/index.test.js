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
import 'utils/mockReactRouterHooks';

import { LoginPage } from 'containers/Session/LoginPage/index';
import LoginForm from 'components/Session/LoginForm';
import EnterpriseForm from 'components/Session/EnterpriseForm';

describe('<LoginPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const props = {
      enterprise: { id: 1, has_enabled_saml: false },
      loginBegin: jest.fn(),
    };
    const wrapper = shallow(<LoginPage {...props} />);
    wrapper.setProps(props);

    expect(spy).not.toHaveBeenCalled();
    expect(wrapper.exists()).toBe(true);
    expect(wrapper.find(EnterpriseForm).length).toBe(0);
    expect(wrapper.find(LoginForm).length).toBe(1);
  });

  it('Displays the password form', () => {
    const wrapper = shallow(<LoginPage />);
    wrapper.setProps({
      enterprise: { id: 1, has_enabled_saml: false },
      loginBegin: jest.fn(),
    });

    expect(wrapper.find(LoginForm).length).toBe(1);
  });
});
