/**
 *
 * Tests for EmailLinks
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { EmailLinks } from '../index';

describe('<EmailLinks />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<EmailLinks classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});