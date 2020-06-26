/**
 *
 * Tests for NewsLinkCommentForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { NewsLinkCommentForm } from '../index';

describe('<NewsLinkCommentForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NewsLinkCommentForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
