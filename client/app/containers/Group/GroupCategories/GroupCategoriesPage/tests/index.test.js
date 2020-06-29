/**
 *
 * Tests for GroupCategoriesPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupCategoriesPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  deleteGroupCategoriesBegin: jest.fn(),
  getGroupCategoriesBegin: jest.fn(),
  categoriesUnmount: jest.fn(),
};
describe('<GroupCategoriesPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupCategoriesPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
