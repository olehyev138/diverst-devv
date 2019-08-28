import React from 'react';
import { shallow } from 'enzyme';
import { unwrap } from '@material-ui/core/test-utils';

import { StyledAuthenticatedLayout } from '../index';
const AuthenticatedLayoutNaked = unwrap(StyledAuthenticatedLayout);

/**
 * TODO:
 *  - test it accepts & renders a child component
 *  - test it redirects if not authenticated
 *  - test it uses props correctly
 */


const props = {
  renderAppBar: true,
  drawerOpen: true,
  drawerToggleCallback: jest.fn(),
  position: '',
  isAdmin: true,
  component: jest.fn()
};

describe('<AuthenticatedLayout />', () => {
  it('Expect to not log errors in console', () => {
    const spy = jest.spyOn(global.console, 'error');
    const wrapper = shallow(<AuthenticatedLayoutNaked {...props} />);

    expect(spy).not.toHaveBeenCalled();
  });

  it('Should render and match the snapshot', () => {
    const wrapper = shallow(<AuthenticatedLayoutNaked {...props} />);

    expect(wrapper).toMatchSnapshot();
  });
});
