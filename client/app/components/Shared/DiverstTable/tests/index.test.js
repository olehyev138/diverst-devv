/**
 *
 * Tests for DiverstTable
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { DiverstTable } from '../index';

import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

const props = {
  dataArray: [],
  columns: [],
  handlePagination: jest.fn(),
  intl,
  classes: {}
};
describe('<DiverstTable />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<DiverstTable intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
