/**
 *
 * Tests for LoginForm
 *
 */


import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { unwrap } from '@material-ui/core/test-utils';

import { StyledLoginForm } from '../index';
const LoginFormNaked = unwrap(StyledLoginForm);

/**
 * TODO:
 *  - test correct actions are dispatched
 */


loadTranslation('./app/translations/en.json');

const props = {
  classes: {},
  loginBegin: jest.fn(),
  email: 'email@email.com',
  passwordError: '',
  width: ''
};

describe('<EnterpriseForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<LoginFormNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallowWithIntl(<LoginFormNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});

