/**
 *
 * Tests for RegionLeadersList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { RegionLeadersList } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  links: {},
  params: {},
  customTexts: { region: 'region' }
};
describe('<RegionLeadersList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<RegionLeadersList intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
