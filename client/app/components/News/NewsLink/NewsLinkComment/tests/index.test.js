/**
 *
 * Tests for NewsLinkComment
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { NewsLinkComment } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  comment: { author: { first_name: 'name' } }
};
describe('<NewsLinkComment />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<NewsLinkComment classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});