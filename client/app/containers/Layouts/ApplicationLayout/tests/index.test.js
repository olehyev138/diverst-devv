import React from 'react';
import { shallow } from 'enzyme';
import { unwrap } from '@material-ui/core/test-utils';

import ApplicationLayout from '../index';
const ApplicationLayoutNaked = unwrap(ApplicationLayout);

/**
 * TODO:
 *  - test it accepts & renders a child component
 */


const props = {
  classes: {},
  component: jest.fn()
};

describe('<ApplicationLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ApplicationLayoutNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallow(<ApplicationLayoutNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
