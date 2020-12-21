/**
 *
 * Tests for DiverstLike
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import { DiverstLike } from '../index';

const props = {
  theme: { palette: { primary: {} } },
  intl,
  customTexts: { erg: 'Group' },
};

loadTranslation('./app/translations/en.json');

describe('<DiverstLike />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<DiverstLike classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
