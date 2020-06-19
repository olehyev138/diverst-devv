/**
 *
 * Tests for DroppableGroupList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
// import DroppableGroupList from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

// Todo:
describe('<DroppableGroupList />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallowWithIntl(<DroppableGroupList intl={intl} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
