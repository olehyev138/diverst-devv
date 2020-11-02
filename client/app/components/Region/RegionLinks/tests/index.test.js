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

const props = {
  currentRegion: {}
};

describe('<RegionLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<RegionLinks classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
