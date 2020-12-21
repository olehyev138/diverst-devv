/**
 *
 * Tests for ThemeProvider
 *
 */

/**
 *
 * TODO:
 *   - Test componentDidMount()
 *   - Test mapStateToProps() & mapDispatchToProps()
 *
 */

import React from 'react';
import { shallowWithIntl, loadTranslation } from 'enzyme-react-intl';
import { shallow } from 'enzyme';
import { intl } from 'tests/mocks/react-intl';

import { ThemeProvider } from 'containers/Shared/ThemeProvider/index';

const props = {
  intl,
  customTexts: { erg: 'Group' },
};

loadTranslation('./app/translations/en.json');

describe('<ThemeProvider />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallowWithIntl(
      <ThemeProvider intl={intl} {...props} />
    );

    expect(spy).not.toHaveBeenCalled();
  });

  xit('should render and match the snapshot', () => {
    const wrapper = shallowWithIntl(
      <ThemeProvider intl={intl} {...props} />
    );

    expect(wrapper).toMatchSnapshot();
  });
});
