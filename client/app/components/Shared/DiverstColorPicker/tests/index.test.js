/**
 *
 * Tests for DiverstColorPicker
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';

import { DiverstColorPicker } from '../index';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';

const props = {
  theme: { palette: { primary: {} } },
  intl,
  customTexts: { erg: 'Group' },
};

loadTranslation('./app/translations/en.json');
describe('<DiverstColorPicker />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<DiverstColorPicker classes={{}} {...props} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
