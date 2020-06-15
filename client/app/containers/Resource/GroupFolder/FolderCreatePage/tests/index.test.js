/**
 *
 * Tests for FolderCreatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { FolderCreatePage } from '../index';
import { intl } from 'tests/mocks/react-intl';
import RouteService from 'utils/routeHelpers';

jest.mock('utils/routeHelpers');
RouteService.mockImplementation(() => ({
  location: {},
  params: jest.fn()
}));

loadTranslation('./app/translations/en.json');
const props = {
  path: 'path',

};
describe('<FolderCreatePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<FolderCreatePage classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
