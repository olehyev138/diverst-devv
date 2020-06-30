/**
 *
 * Tests for BrandingLayout
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
// import MockBrandingLayout from './mock';
import BrandingLayout from '../index';
import configureStore from 'redux-mock-store';
const mockStore = configureStore([]);

describe('<BrandingLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<BrandingLayout classes={{}} store={mockStore()} />).dive();

    expect(spy).not.toHaveBeenCalled();
  });
});
