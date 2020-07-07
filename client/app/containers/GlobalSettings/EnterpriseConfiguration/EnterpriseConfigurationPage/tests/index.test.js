/**
 *
 * Tests for EnterpriseConfigurationPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import 'utils/mockReactRouterHooks';
import { EnterpriseConfigurationPage } from '../index';

loadTranslation('./app/translations/en.json');

describe('<EnterpriseConfigurationPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<EnterpriseConfigurationPage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
