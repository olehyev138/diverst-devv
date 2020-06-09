/**
 *
 * Tests for EmailForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { EmailForm } from '../index';

import { intl } from './react-intl';

loadTranslation('./app/translations/en.json');

describe('<EmailForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<EmailForm intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
