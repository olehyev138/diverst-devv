/**
 *
 * Tests for GroupLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import MockGroupLayout from './mock';

describe('<GroupLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<MockGroupLayout classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
