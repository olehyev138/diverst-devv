import React from 'react';
import { shallow } from 'enzyme';

import GroupLayout from '../index';

/**
 * TODO:
 *  - test it accepts & renders a child component
 *  - test it renders ApplicationLayout as a child component
 */


const props = {
  classes: {},
  component: jest.fn()
};

describe('<GroupLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<GroupLayout {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallow(<GroupLayout {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
