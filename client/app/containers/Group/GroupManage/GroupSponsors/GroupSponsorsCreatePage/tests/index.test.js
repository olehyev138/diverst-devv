/**
 *
 * Tests for SponsorCreatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
// import { SponsorCreatePage } from '../index';
import { intl } from 'tests/mocks/react-intl';

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');
loadTranslation('./app/translations/en.json');
// Todo: TypeError: Invalid URL
describe('<SponsorCreatePage />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallowWithIntl(<SponsorCreatePage classes={{}} intl={intl} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
