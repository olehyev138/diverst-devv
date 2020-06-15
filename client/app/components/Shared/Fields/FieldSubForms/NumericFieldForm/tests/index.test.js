/**
 *
 * Tests for NumericFieldForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { NumericFieldForm } from '../index';

const props = {
  fieldsName: 'fieldsName',
  index: 0,
  formikProps: { values: { fieldsName: [{ title: {} }] } },
  arrayHelpers: {},
};

describe('<NumericFieldForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<NumericFieldForm classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
