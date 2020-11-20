/**
 *
 * Tests for UserDashboard
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { SponsorCard } from '../index';

loadTranslation('./app/translations/en.json');

describe('<SponsorCard />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<SponsorCard />);

    expect(spy).not.toHaveBeenCalled();
  });
});