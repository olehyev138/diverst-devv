/**
 *
 * Tests for DiverstShowLoader
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import DiverstShowLoader from '../index';

describe('<DiverstShowLoader />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstShowLoader classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
