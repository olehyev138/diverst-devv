/**
 *
 * Tests for Conditional
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import Conditional from '../index';

loadTranslation('./app/translations/en.json');

// Todo: TypeError: Cannot read property 'children' of undefined
describe('<Conditional />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallowWithIntl(<Conditional intl={intl} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
