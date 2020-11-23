/**
 *
 * Tests for EventsTable
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { EventsTable } from '../index';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

const props = {
  archives: [],
  intl,
  customTexts: { erg: 'Group' },
};

describe('<EventsTable />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<EventsTable intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
