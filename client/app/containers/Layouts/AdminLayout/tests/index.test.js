/**
 *
 * Tests for AdminLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { AdminLayout } from '../index';

describe('<AdminLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AdminLayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
