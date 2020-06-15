/**
 *
 * Tests for ApplicationFooter
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { ApplicationFooter } from '../index';

describe('<ApplicationFooter />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ApplicationFooter classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
