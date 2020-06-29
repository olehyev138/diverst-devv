/**
 *
 * Tests for CustomTextEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { CustomTextEditPage } from '../index';
import { intl } from 'tests/mocks/react-intl';
import 'utils/mockReactRouterHooks';

loadTranslation('./app/translations/en.json');

describe('<CustomTextEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<CustomTextEditPage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
