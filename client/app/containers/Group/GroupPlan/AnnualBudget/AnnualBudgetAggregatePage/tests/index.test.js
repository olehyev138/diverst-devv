/**
 *
 * Tests for AnnualBudgetsPage
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import 'utils/mockReactRouterHooks';
import { AnnualBudgetsPage } from '../index';

describe('<AnnualBudgetsPage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AnnualBudgetsPage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
