/**
 *
 * Tests for SocialLinkEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { SocialLinkEditPage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');
// Todo: TypeError: Invalid URL
describe('<SocialLinkEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<SocialLinkEditPage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
