/**
 *
 * Tests for EventLite
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { EventLite } from '../index';

loadTranslation('./app/translations/en.json');

describe('<EventLite />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<EventLite />);

    expect(spy).not.toHaveBeenCalled();
  });
});
