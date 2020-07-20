/**
 *
 * Tests for InviteForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { InviteForm } from '../index';

describe('<InviteForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<InviteForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});