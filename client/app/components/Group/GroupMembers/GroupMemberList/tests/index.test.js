/**
 *
 * Tests for GroupMemberList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { GroupMemberList } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  memberType: '',
  MemberTypes: [],
  handleChangeTab: jest.fn(),
  handleFilterChange: jest.fn(),
  links: {},
  params: {}
};
describe('<GroupMemberList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<GroupMemberList classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
