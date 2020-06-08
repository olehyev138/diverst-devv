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

loadTranslation('./app/translations/en.json');

const props = {
  archives: [],
};

describe('<ResourcesTable />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<ResourcesTable {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
