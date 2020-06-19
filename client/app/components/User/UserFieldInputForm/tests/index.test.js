/**
 *
 * Tests for UserFieldInputForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { UserFieldInputForm } from '../index';

describe('<UserFieldInputForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<UserFieldInputForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
