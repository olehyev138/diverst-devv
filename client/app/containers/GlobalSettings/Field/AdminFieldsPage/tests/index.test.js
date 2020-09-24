/**
 *
 * Tests for FieldListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import 'utils/mockReactRouterHooks';
import { AdminFieldsPage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  getFieldsBegin: jest.fn(),
  createFieldBegin: jest.fn(),
  updateFieldBegin: jest.fn(),
  updateFieldPositionBegin: jest.fn(),
  deleteFieldBegin: jest.fn(),
  fields: [],
  fieldUnmount: jest.fn(),
};
describe('<AdminFieldsPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<AdminFieldsPage classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
