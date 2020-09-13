/**
 *
 * Tests for FolderPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { FolderPage } from '../index';

describe('<FolderPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FolderPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});