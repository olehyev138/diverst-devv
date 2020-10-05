/**
 *
 * Tests for SSOLandingPage
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

import { SSOLandingPage } from 'containers/Session/SSOLandingPage/index';
import SSOLanding from 'components/Session/SSOLanding';

describe('<SSOLandingPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const props = {
      enterprise: { id: 1, has_enabled_saml: true },
      showSnackbar: jest.fn(),
      refresh: jest.fn(),
      ssoLinkBegin: jest.fn(),
      ssoLoginBegin: jest.fn(),
    };
    const wrapper = shallow(<SSOLandingPage {...props} />);
    wrapper.setProps(props);

    expect(spy).not.toHaveBeenCalled();
    expect(wrapper.exists()).toBe(true);
    expect(wrapper.find(SSOLanding).length).toBe(1);
  });

  xit('Calls refresh', () => {
    const wrapper = shallow(<SSOLandingPage />);
    const props = {
      enterprise: { id: 1, has_enabled_saml: true },
      showSnackbar: jest.fn(),
      refresh: jest.fn(),
      ssoLinkBegin: jest.fn(),
      ssoLoginBegin: jest.fn(),
      location: {
        search: '?errorMessage=Hello, How are you'
      }
    };

    const spy1 = jest.spyOn(props, 'refresh');
    const spy2 = jest.spyOn(props, 'showSnackbar');

    wrapper.setProps(props);

    expect(spy1).toHaveBeenCalledTimes(1);
    expect(spy2).toHaveBeenCalledTimes(1);
  });

  xit('Calls ssoLoginBegin', () => {
    const wrapper = shallow(<SSOLandingPage />);
    const props = {
      enterprise: { id: 1, has_enabled_saml: true },
      showSnackbar: jest.fn(),
      refresh: jest.fn(),
      ssoLinkBegin: jest.fn(),
      ssoLoginBegin: jest.fn(),
      location: {
        search: '?userToken=Hello'
      }
    };

    const spy = jest.spyOn(props, 'ssoLoginBegin');

    wrapper.setProps(props);

    expect(spy).toHaveBeenCalledTimes(1);
  });
});
