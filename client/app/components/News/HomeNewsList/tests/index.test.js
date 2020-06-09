/**
 *
 * Tests for NewsFeed
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { NewsFeed } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

describe('<NewsFeed />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<NewsFeed intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
