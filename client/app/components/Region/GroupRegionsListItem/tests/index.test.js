/**
 *
 * Tests for GroupRegionsListItem
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupRegionsListItem } from '../index';

const props = {
  item: {},
};

describe('<GroupRegionsListItem />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupRegionsListItem classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
