/**
 *
 * Tests for OutcomeForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { OutcomeForm } from '../index';

describe('<OutcomeForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<OutcomeForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
