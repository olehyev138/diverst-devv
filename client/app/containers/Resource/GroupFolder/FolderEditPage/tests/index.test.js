/**
 *
 * Tests for FolderEditPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { FolderEditPage } from '../index';
import { intl } from 'tests/mocks/react-intl';
import 'utils/mockReactRouterHooks';

loadTranslation('./app/translations/en.json');

const props = {
  path: 'path',
};

describe('<FolderEditPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<FolderEditPage classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
