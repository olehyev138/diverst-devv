/**
 *
 * Tests for DiverstPagination
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import { DiverstPagination } from '../index';

const props = {
  handlePagination: jest.fn(),
  intl,
  customTexts: { erg: 'Group' },
};

loadTranslation('./app/translations/en.json');
describe('<DiverstPagination />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<DiverstPagination classes={{}} {...props} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
