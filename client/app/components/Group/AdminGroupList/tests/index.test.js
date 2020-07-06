/**
 *
 * Tests for AdminGroupList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
// import { AdminGroupList } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');

// Todo
describe('<AdminGroupList />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallowWithIntl(<AdminGroupList intl={intl} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
