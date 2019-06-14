/**
 *
 * Tests for LoginForm
 *
 */


import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { unwrap } from '@material-ui/core/test-utils';

import { LoginFormInner, StyledLoginForm } from '../index';
const LoginFormNaked = unwrap(StyledLoginForm);

/**
 * TODO:
 *  - test correct actions are dispatched
 *  - test validations
 */


loadTranslation('./app/translations/en.json');

const innerProps = {
  classes: {},
  handleChange: jest.fn,
  handleBlur: jest.fn,
  errors: { email: '', password: '' },
  touched: true,
  values: { email: '', password: '' }
}

const props = {
  classes: {},
  loginBegin: jest.fn(),
  email: 'email@email.com',
  passwordError: '',
  width: ''
};

describe('<EnterpriseForm />', () => {
  describe('<EnterpriseFormInner />', () => {
    it('Expect to not log errors in console', () => {
      const spy = jest.spyOn(global.console, 'error');
      const wrapper = shallowWithIntl(<LoginFormInner {...innerProps} />);

      expect(spy).not.toHaveBeenCalled();
    });

    it('Should render and match the snapshot', () => {
      const wrapper = shallowWithIntl(<LoginFormInner {...innerProps} />);

      expect(wrapper).toMatchSnapshot();
    });
  });

  describe('Formik', () => {
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
});
