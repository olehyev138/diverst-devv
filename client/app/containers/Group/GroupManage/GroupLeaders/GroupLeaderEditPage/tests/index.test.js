/**
 *
 * Tests for GroupLeaderEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { GroupLeaderEditPage } from '../index';
import { intl } from 'tests/mocks/react-intl';

jest.mock('utils/routeHelpers');
const RouteService = require.requireMock('utils/routeHelpers');
loadTranslation('./app/translations/en.json');

describe('<GroupLeaderEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<GroupLeaderEditPage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
