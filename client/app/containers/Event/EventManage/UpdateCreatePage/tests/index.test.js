/**
 *
 * Tests for UpdateCreatePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { UpdateCreatePage } from '../index';
import { intl } from 'tests/mocks/react-intl';
import 'utils/mockReactRouterHooks';

loadTranslation('./app/translations/en.json');
const props = {
  getUpdatePrototypeBegin: jest.fn(),
  createUpdateBegin: jest.fn(),
  updateFieldDataBegin: jest.fn(),
  updatesUnmount: jest.fn(),
};
describe('<UpdateCreatePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<UpdateCreatePage classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
