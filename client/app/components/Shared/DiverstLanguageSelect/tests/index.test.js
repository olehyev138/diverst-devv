/**
 *
 * Tests for DiverstLanguageSelect
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstLanguageSelect } from '../index';

describe('<DiverstLanguageSelect />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstLanguageSelect classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
