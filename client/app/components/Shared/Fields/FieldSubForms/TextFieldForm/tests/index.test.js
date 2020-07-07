/**
 *
 * Tests for TextFieldForm
 *
 * @see https://github.com/react-boilerplate/react-boilerplate/tree/master/docs/testing
 *
 */

import React from 'react';
import { shallow } from 'enzyme';
import { TextFieldForm } from '../index';

const props = {
  fieldsName: 'fieldsName',
  index: 0,
  formikProps: { values: { fieldsName: [{ title: {} }] } },
  arrayHelpers: {},
};
describe('<TextFieldForm />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<TextFieldForm classes={{}} {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });
});
