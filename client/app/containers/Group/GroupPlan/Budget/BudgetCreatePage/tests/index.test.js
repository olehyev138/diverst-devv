/**
 *
 * Tests for BudgetCreatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import { BudgetCreatePage } from '../index';

import RouteService from 'utils/routeHelpers';

jest.mock('utils/routeHelpers');
RouteService.mockImplementation(() => ({
  location: {},
  params: jest.fn()
}));
const props = {
  getUpdateBegin: jest.fn(),
  getUpdateSuccess: jest.fn(),
  deleteUpdateBegin: jest.fn(),
  updateUpdateBegin: jest.fn(),
  updateFieldDataBegin: jest.fn(),
  updatesUnmount: jest.fn()
};
loadTranslation('./app/translations/en.json');

describe('<BudgetCreatePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<BudgetCreatePage classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
