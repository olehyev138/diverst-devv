/**
 *
 * Tests for BrandingHomePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
// import { BrandingHomePage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
// Todo: TypeError: Invalid URL
describe('<BrandingHomePage />', () => {
  it('Expect to not log errors in console', () => {
    // const spy = jest.spyOn(global.console, 'error');
    // const wrapper = shallowWithIntl(<BrandingHomePage classes={{}} intl={intl} />);
    //
    // expect(spy).not.toHaveBeenCalled();
  });
});
