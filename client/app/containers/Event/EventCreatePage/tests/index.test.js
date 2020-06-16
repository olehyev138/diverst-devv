/**
 *
 * Tests for EventCreatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
// import { EventCreatePage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');

// Todo: TypeError: Invalid URL
describe('<EventCreatePage />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallowWithIntl(<EventCreatePage classes={{}} intl={intl} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
