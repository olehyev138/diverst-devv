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
import { AnnualBudgetsAggregatePage } from '../index';

describe('<AnnualBudgetsAggregatePage />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AnnualBudgetsAggregatePage classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
