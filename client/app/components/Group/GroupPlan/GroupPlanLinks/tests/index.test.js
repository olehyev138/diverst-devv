/**
 *
 * Tests for GroupPlanLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupPlanLinks } from '../index';

const props = {
  currentGroup: {}
};
describe('<GroupPlanLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupPlanLinks classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
