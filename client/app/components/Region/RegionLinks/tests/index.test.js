/**
 *
 * Tests for RegionLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { RegionLinks } from '../index';

describe('<RegionLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<RegionLinks classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
