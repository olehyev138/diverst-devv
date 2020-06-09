/**
 *
 * Tests for GlobalSettingsLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GlobalSettingsLinks } from '../index';

describe('<GlobalSettingsLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GlobalSettingsLinks classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
