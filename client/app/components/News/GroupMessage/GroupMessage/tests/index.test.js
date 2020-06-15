/**
 *
 * Tests for GroupMessage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupMessage } from '../index';

describe('<GroupMessage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupMessage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
