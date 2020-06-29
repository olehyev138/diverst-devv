/**
 *
 * Tests for FoldersPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { FoldersPage } from '../index';
import 'utils/mockReactRouterHooks';

const props = {
  getFoldersBegin: jest.fn(),
  foldersUnmount: jest.fn(),
};
describe('<FoldersPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FoldersPage classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
