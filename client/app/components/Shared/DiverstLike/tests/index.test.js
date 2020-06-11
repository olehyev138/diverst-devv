/**
 *
 * Tests for DiverstLike
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstLike } from '../index';

describe('<DiverstLike />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstLike classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
