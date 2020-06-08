/**
 *
 * Tests for EventListItem
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { EventListItem } from '../index';

loadTranslation('./app/translations/en.json');
const props = {
  item: {},
};

describe('<EventListItem />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<EventListItem classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
