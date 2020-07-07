/**
 *
 * Tests for ResponsiveTabs
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { ResponsiveTabs } from '../index';

describe('<ResponsiveTabs />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ResponsiveTabs classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
