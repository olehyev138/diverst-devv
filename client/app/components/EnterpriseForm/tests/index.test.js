/**
 *
 * Tests for EnterpriseForm
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { unwrap } from '@material-ui/core/test-utils';

import { EnterpriseFormInner, StyledEnterpriseForm } from '../index';
const EnterpriseFormNaked = unwrap(StyledEnterpriseForm);

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
  errors: { email: '' },
  touched: true,
  values: { email: '' }
};

const props = {
  classes: {},
  findEnterpriseBegin: jest.fn(),
  enterpriseError: '',
  emailError: ''
};


describe('<EnterpriseForm />', () => {
  describe('<EnterpriseFormInner />', () => {
    it('Expect to not log errors in console', () => {
      const spy = jest.spyOn(global.console, 'error');
      const wrapper = shallowWithIntl(<EnterpriseFormInner {...innerProps} />);

      expect(spy).not.toHaveBeenCalled();
    });

    it('Should render and match the snapshot', () => {
      const wrapper = shallowWithIntl(<EnterpriseFormInner {...innerProps} />);

      expect(wrapper).toMatchSnapshot();
    });
  });

  describe('Formik', () => {
    it('Expect to not log errors in console', () => {
      const spy = jest.spyOn(global.console, 'error');
      const wrapper = shallowWithIntl(<EnterpriseFormNaked {...props} />);

      expect(spy).not.toHaveBeenCalled();
    });

    it('Should render and match the snapshot', () => {
      const wrapper = shallowWithIntl(<EnterpriseFormNaked {...props} />);

      expect(wrapper).toMatchSnapshot();
    });
  });
});
