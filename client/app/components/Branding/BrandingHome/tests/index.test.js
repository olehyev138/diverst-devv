/**
 *
 * Tests for UserDashboard
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { BrandingHome } from '../index';

loadTranslation('./app/translations/en.json');

// Todo: TypeError: Invalid URL

// describe('<BrandingHome />', () => {
//   it('Expect to not log errors in console', () => {
//     const spy = jest.spyOn(global.console, 'error');
//     const wrapper = shallowWithIntl(<BrandingHome />);
//
//     expect(spy).not.toHaveBeenCalled();
//   });
// });
