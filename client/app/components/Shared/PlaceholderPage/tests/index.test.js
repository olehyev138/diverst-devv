/**
 *
 * Tests for PlaceholderPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import PlaceholderPage from '../index';

describe('<PlaceholderPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<PlaceholderPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
