/**
 *
 * Tests for GlobalSettingsLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MockGlobalSettingsLayout from './mock';

describe('<GlobalSettingsLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MockGlobalSettingsLayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
