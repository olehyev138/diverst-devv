/**
 *
 * Tests for SelectFormForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { SelectFormForm } from '../index';

describe('<SelectFormForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<SelectFormForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
