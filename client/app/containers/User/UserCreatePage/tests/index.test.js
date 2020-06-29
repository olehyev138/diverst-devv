/**
 *
 * Tests for UserCreatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { UserCreatePage } from '../index';
import { intl } from 'tests/mocks/react-intl';
import 'utils/mockReactRouterHooks';

loadTranslation('./app/translations/en.json');

describe('<UserCreatePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<UserCreatePage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
