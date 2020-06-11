/**
 *
 * Tests for EventsList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
// import { EventsList } from '../index';
import { intl } from 'tests/mocks/react-intl';
const { EventsList } = require.requireMock('../index.js');

loadTranslation('./app/translations/en.json');
const props = {
  events: [],
  links: {},
};

describe('<EventsList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<EventsList classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
