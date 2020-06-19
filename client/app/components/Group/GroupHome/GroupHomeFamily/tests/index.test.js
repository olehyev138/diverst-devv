/**
 *
 * Tests for GroupHomeFamily
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupHomeFamily } from '../index';

const props = {
  currentGroup: { children: [] },
};
describe('<GroupHomeFamily />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupHomeFamily classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
