/**
 *
 * Tests for EventsTable
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { shallow } from 'enzyme';

import { EventsTable } from '../index';

loadTranslation('./app/translations/en.json');

const props = {
  archives: [],
};

describe('<EventsTable />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<EventsTable {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
