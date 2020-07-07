/**
 *
 * Tests for NotFoundPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { NotFoundPage } from '../index';

describe('<NotFoundPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NotFoundPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
