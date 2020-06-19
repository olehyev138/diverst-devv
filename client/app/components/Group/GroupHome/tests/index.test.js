/**
 *
 * Tests for GroupHome
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { GroupHome } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  currentGroup: {}
};
describe('<GroupHome />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<GroupHome classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
