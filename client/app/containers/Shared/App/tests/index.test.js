/**
 *
 * Tests for App
 *
 *
 */

import React from 'react';
import { shallow } from 'enzyme';

import App from 'containers/Shared/App/index';

describe('<App />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<App />);

    expect(spy).not.toHaveBeenCalled();
  });
});
