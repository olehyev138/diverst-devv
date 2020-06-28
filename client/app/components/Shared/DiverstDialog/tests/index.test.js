/**
 *
 * Tests for DiverstDialog
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstDialog } from '../index';

describe('<DiverstDialog />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstDialog classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
