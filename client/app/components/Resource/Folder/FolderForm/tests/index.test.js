/**
 *
 * Tests for FolderForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { FolderForm } from '../index';

describe('<FolderForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FolderForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
