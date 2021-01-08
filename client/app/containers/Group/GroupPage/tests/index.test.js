/**
 *
 * Tests for GroupPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { GroupPage } from '../index';

const props = {
  children: <p></p>,
};
describe('<GroupPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});