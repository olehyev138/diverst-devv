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
import LoginForm from 'components/Session/LoginForm';
import EnterpriseForm from 'components/Session/EnterpriseForm';

describe('<LoginPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<LoginPage />);

    expect(spy).not.toHaveBeenCalled();
    expect(wrapper.exists()).toBe(true);
    expect(wrapper.find(EnterpriseForm).length).toBe(1);
    expect(wrapper.find(LoginForm).length).toBe(0);
  });

  it('Displays the password form', () => {
    const wrapper = shallow(<LoginPage />);
    wrapper.setProps({
      enterprise: { id: 1, has_enabled_saml: false }
    });

    expect(wrapper.find(LoginForm).length).toBe(1);
  });

  it('Calls ssoLinkBegin', () => {
    const wrapper = shallow(<LoginPage />);
    const props = {
      enterprise: { id: 1, has_enabled_saml: true },
      ssoLinkBegin: () => {}
    };
    const spy = jest.spyOn(props, 'ssoLinkBegin');

    wrapper.setProps(props);

    expect(spy).toHaveBeenCalledTimes(1);
    expect(wrapper.find(EnterpriseForm).length).toBe(1);
  });

  it('Calls refresh', () => {
    const location = {
      search: '?errorMessage=Hello, How are you'
    };
    const props = {
      refresh: () => {},
      showSnackbar: () => {},
      location
    };

    const spy1 = jest.spyOn(props, 'refresh');
    const spy2 = jest.spyOn(props, 'showSnackbar');

    shallow(<LoginPage {...props} />);

    expect(spy1).toHaveBeenCalledTimes(1);
    expect(spy2).toHaveBeenCalledTimes(1);
  });

  it('Calls ssoLoginBegin', () => {
    const location = {
      search: '?userToken=Hello&policyGroupId=1'
    };
    const props = {
      ssoLoginBegin: () => {},
      location
    };

    const spy1 = jest.spyOn(props, 'ssoLoginBegin');

    shallow(<LoginPage {...props} />);

    expect(spy1).toHaveBeenCalledTimes(1);
  });
});
