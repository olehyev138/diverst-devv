/**
 *
 * Tests for UserDashboard
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { SponsorList } from '../index';

loadTranslation('./app/translations/en.json');
const props = {
  links: { sponsorNew: 'path' },
  params: { count: 1 }
};

describe('<SponsorList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<SponsorList classes={{}} {...props}/>);

    expect(spy).not.toHaveBeenCalled();
  });
});
