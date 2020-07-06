/**
 *
 * Tests for DiverstFormattedMessage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { intl } from 'tests/mocks/react-intl';
import { DiverstFormattedMessage } from '../index';


describe('<DiverstFormattedMessage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<DiverstFormattedMessage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
