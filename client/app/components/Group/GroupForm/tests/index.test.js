/**
 *
 * Tests for GroupForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupForm } from '../index';

describe('<GroupForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
