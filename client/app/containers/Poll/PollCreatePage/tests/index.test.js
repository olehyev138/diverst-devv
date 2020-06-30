/**
 *
 * Tests for PollCreatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import 'utils/mockReactRouterHooks';
import { PollCreatePage } from '../index';

loadTranslation('./app/translations/en.json');

describe('<PollCreatePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<PollCreatePage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
