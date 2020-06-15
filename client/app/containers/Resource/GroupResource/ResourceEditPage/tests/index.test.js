/**
 *
 * Tests for ResourceEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
// import { ResourceEditPage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');
// Todo: TypeError: Invalid URL
describe('<ResourceEditPage />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallowWithIntl(<ResourceEditPage classes={{}} intl={intl} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
