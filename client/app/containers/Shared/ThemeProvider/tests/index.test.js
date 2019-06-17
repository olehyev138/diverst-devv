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
import { shallow } from 'enzyme/build';

import { ThemeProvider } from 'containers/Shared/ThemeProvider/index';

describe('<ThemeProvider />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(
      <ThemeProvider primary='#7B77C9' secondary='#8A8A8A' />
    );

    expect(spy).not.toHaveBeenCalled();
  });

  it('should render and match the snapshot', () => {
    const wrapper = shallow(
      <ThemeProvider primary='#7B77C9' secondary='#8A8A8A' />
    );

    expect(wrapper).toMatchSnapshot();
  });
});
