/**
 *
 * Tests for InvalidSessionDetector
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { InvalidSessionDetector } from '../index';

describe('<InvalidSessionDetector />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<InvalidSessionDetector classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
