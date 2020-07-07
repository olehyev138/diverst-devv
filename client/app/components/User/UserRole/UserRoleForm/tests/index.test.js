/**
 *
 * Tests for UserRoleForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UserRoleForm } from '../index';

describe('<UserRoleForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserRoleForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
