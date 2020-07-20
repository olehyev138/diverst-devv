/**
 *
 * Tests for GroupMessageCommentForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { GroupMessageCommentForm } from '../index';

describe('<GroupMessageCommentForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupMessageCommentForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
