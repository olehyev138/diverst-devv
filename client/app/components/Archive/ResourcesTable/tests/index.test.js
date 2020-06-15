/**
 *
 * Tests for EventsTable
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { ResourcesTable } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

const props = {
  archives: [],
};

describe('<ResourcesTable />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<ResourcesTable intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
