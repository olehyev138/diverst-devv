import React from 'react';
import { shallow } from 'enzyme';
import WithPermission from '../index';

describe('<WithPermission />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<WithPermission />);

    expect(spy).not.toHaveBeenCalled();
  });
});
