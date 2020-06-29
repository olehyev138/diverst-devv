/**
 *
 * Tests for SponsorListPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SponsorListPage } from '../index';
import 'utils/mockReactRouterHooks';

describe('<SponsorListPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SponsorListPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
