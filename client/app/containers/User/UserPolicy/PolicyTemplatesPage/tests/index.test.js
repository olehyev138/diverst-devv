/**
 *
 * Tests for PolicyTemplatesPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { PolicyTemplatesPage } from '../index';

describe('<PolicyTemplatesPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<PolicyTemplatesPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
