/**
 *
 * Tests for UpdateEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import 'utils/mockReactRouterHooks';
import { UpdateEditPage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  getUpdateBegin: jest.fn(),
  getUpdateSuccess: jest.fn(),
  deleteUpdateBegin: jest.fn(),
  updatesUnmount: jest.fn(),
  updateUpdateBegin: jest.fn(),
  updateFieldDataBegin: jest.fn(),
};
describe('<UpdateEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<UpdateEditPage classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
