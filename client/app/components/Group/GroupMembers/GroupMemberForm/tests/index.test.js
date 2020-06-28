/**
 *
 * Tests for GroupMemberForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupMemberForm } from '../index';

describe('<GroupMemberForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupMemberForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
