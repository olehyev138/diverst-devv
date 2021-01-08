/**
 *
 * Tests for RegionHome
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { RegionHome } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
const props = {
  currentRegion: {}
};
describe('<RegionHome />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<RegionHome classes={{}} intl={intl} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});