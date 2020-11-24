/**
 *
 * Tests for GroupLeaderForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { GroupLeaderForm } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  dataArray: [],
  columns: [],
  handlePagination: jest.fn(),
  intl,
  classes: {},
  customTexts: { erg: 'Group' }
};

describe('<GroupLeaderForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<GroupLeaderForm intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
