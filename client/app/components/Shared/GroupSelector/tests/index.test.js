/**
 *
 * Tests for GroupSelector
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import GroupSelector from '../index';

import { intl } from 'tests/mocks/react-intl';

import configureStore from 'redux-mock-store';
const mockStore = configureStore([]);

loadTranslation('./app/translations/en.json');

const props = {
  groupField: '',
  label: <p></p>,
  handleChange: jest.fn(),
  setFieldValue: jest.fn(),
  values: {},
  queryScopes: [],
  getGroupsBegin: jest.fn(),
  groupListUnmount: jest.fn(),
  groups: [],
};
describe('<GroupSelector />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<GroupSelector classes={{}} {...props} store={mockStore()} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
