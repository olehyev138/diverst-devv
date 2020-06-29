/**
 *
 * Tests for EmailsPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { EmailsPage } from '../index';
import 'utils/mockReactRouterHooks';

describe('<EmailsPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<EmailsPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
