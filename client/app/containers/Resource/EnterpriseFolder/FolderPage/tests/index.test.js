/**
 *
 * Tests for FolderPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { FolderPage } from '../index';
import 'utils/mockReactRouterHooks';

describe('<FolderPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FolderPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
