/**
 *
 * Tests for DiverstSwitch
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import DiverstSwitch from '../index';

describe('<DiverstSwitch />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstSwitch classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
