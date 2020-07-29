import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { PasswordResetForm, PasswordResetFormInner } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

describe('<PasswordResetForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<PasswordResetForm intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
