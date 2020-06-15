/**
 *
 * Tests for FieldsSubForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { FieldsSubForm } from '../index';

describe('<FieldsSubForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<FieldsSubForm classes={{}} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
