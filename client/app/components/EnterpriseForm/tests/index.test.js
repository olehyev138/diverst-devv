/**
 *
 * Tests for EnterpriseForm
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { unwrap } from '@material-ui/core/test-utils';

import { StyledEnterpriseForm } from '../index';
const EnterpriseFormNaked = unwrap(StyledEnterpriseForm);

/**
 * TODO:
 *  - test correct actions are dispatched
 */

loadTranslation('./app/translations/en.json');

const props = {
  classes: {},
  findEnterpriseBegin: jest.fn(),
  enterpriseError: '',
  emailError: ''
};

describe('<EnterpriseForm />', () => {
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
