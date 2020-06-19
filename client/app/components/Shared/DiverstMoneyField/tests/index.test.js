/**
 *
 * Tests for DiverstMoneyField
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { DiverstMoneyField } from '../index';

describe('<DiverstMoneyField />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<DiverstMoneyField classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
