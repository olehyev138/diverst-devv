/**
 *
 * Tests for RegionHomePage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { RegionHomePage } from '../index';

describe('<RegionHomePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<RegionHomePage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
