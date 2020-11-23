/**
 *
 * Tests for DiverstDialog
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import { DiverstDialog } from '../index';

loadTranslation('./app/translations/en.json');

const props = {
  intl,
  customTexts: { erg: 'Group' },
  classes: {},
  content: { id: 'diverst.containers.App.texts.erg' }
};

describe('<DiverstDialog />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<DiverstDialog intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
