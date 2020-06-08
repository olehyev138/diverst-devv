/**
 *
 * Tests for EventForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { EventForm } from '../index';

loadTranslation('./app/translations/en.json');
const props = {
  currentGroup: {},
};

// Todo: TypeError: Invalid URL
// describe('<EventForm />', () => {
//   it('Expect to not log errors in console', () => {
//     const spy = jest.spyOn(global.console, 'error');
//     const wrapper = shallowWithIntl(<EventForm {...props} />);
//
//     expect(spy).not.toHaveBeenCalled();
//   });
// });
