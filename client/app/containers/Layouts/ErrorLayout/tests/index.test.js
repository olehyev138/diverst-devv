import React from 'react';
import { shallow } from 'enzyme';
import { unwrap } from '@material-ui/core/test-utils';

import { StyledErrorLayout } from '../index';
const ErrorLayoutNaked = unwrap(StyledErrorLayout);

/**
 * TODO:
 *  - test it accepts & renders a child component
 *  - test it renders the applicationlayout as a child
 */


const props = {
  classes: {},
  component: jest.fn()
};

describe('<ErrorLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<ErrorLayoutNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallow(<ErrorLayoutNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
