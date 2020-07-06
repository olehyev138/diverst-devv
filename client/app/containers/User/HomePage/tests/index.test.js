/**
 *
 * Tests for HomePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { HomePage } from '../index';
import { intl } from 'tests/mocks/react-intl';

loadTranslation('./app/translations/en.json');
describe('<HomePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(<HomePage classes={{}} intl={intl} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallowWithIntl(<HomePage classes={{}} intl={intl} />);

    expect(wrapper).toMatchSnapshot();
  });
});
