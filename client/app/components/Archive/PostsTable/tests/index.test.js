/**
 *
 * Tests for EventsTable
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { PostsTable } from '../index';

loadTranslation('./app/translations/en.json');
const props = {
  archives: [],
};
describe('<PostsTable />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<PostsTable {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
