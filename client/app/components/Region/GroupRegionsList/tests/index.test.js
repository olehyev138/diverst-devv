/**
 *
 * Tests for GroupRegionsList
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupRegionsList } from '../index';

describe('<GroupRegionsList />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupRegionsList classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
